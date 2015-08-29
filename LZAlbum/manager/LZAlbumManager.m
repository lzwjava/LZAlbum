//
//  MCFeedManager.m
//  LZAlbum
//
//  Created by lzw on 15/4/1.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumManager.h"

@interface LZAlbumManager()

@property (nonatomic, strong) NSMutableDictionary *cachedUsers;

@end

@implementation LZAlbumManager

+(LZAlbumManager*)manager{
    static LZAlbumManager* albumManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        albumManager=[[LZAlbumManager alloc] init];
    });
    return albumManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachedUsers = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)createAlbumWithText:(NSString*)text photos:(NSArray*)photos error:(NSError**)error{
    if(text==nil){
        text=@"";
    }
    NSMutableArray* photoFiles=[NSMutableArray array];
    NSError* theError;
    for(UIImage* photo in photos){
        AVFile* photoFile=[AVFile fileWithData:UIImageJPEGRepresentation(photo, 0.6)];
        [photoFile save:&theError];
        if (theError) {
            *error = theError;
            return;
        }
        [photoFiles addObject:photoFile];
    }
    AVUser* user=[AVUser currentUser];
    LCAlbum* album=[LCAlbum object];
    album.creator=user;
    album.albumContent=text;
    album.albumPhotos=photoFiles;
    album.isDel=NO;
    album.digUsers=[NSArray array];
    album.comments=[NSArray array];
    [album save:&theError];
    *error=theError;
}

-(void)findAlbumWithBlock:(AVArrayResultBlock)block{
    AVQuery* q=[LCAlbum query];
    [q orderByDescending:KEY_CREATED_AT];
    [q includeKey:KEY_ALBUM_PHOTOS];
    [q includeKey:KEY_COMMENTS];
    [q setLimit:100];
    [q whereKey:KEY_IS_DEL equalTo:@(NO)];
    [q setCachePolicy:kAVCachePolicyNetworkElseCache];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            NSMutableSet *userIds = [NSMutableSet set];
            [self iterateUsersInAlbums:objects block:^(AVUser *user) {
                [userIds addObject:user.objectId];
            }];
            [self cacheUsersByIds:userIds block:^(BOOL succeeded, NSError *error) {
                if (error) {
                    block(objects, error);
                } else {
                    [self iterateUsersInAlbums:objects block:^(AVUser *user) {
                        [self fillPointerUser:user];
                    }];
                    block(objects ,nil);
                }
            }];
        }
    }];
}

typedef void (^AVUserHandleBlock)(AVUser *user);

- (void)iterateUsersInAlbums:(NSArray *)albums block:(AVUserHandleBlock)block {
    for (LCAlbum *album in albums) {
        if (album.creator) {
            block(album.creator);
        }
        for (AVUser *digUser in album.digUsers) {
            block(digUser);
        }
        for (LZComment *comment in album.comments) {
            if (comment.commentUser) {
                block(comment.commentUser);
            }
            if (comment.toUser) {
                block(comment.toUser);
            }
        }
    }
}

- (void)fillPointerUser:(AVUser *)pointerUser {
    AVUser *fullUser = [self lookUpUserById:pointerUser.objectId];
    [pointerUser objectFromDictionary:[fullUser dictionaryForObject]];
}

#pragma mark - User Cache

- (AVUser *)lookUpUserById:(NSString *)objectId {
    return self.cachedUsers[objectId];
}

- (void)addUserToCache:(AVUser *)user {
    self.cachedUsers[user.objectId] = user;
}

- (void)cacheUsersByIds:(NSMutableSet *)userIds block:(AVBooleanResultBlock)block {
    NSMutableSet *uncached = [NSMutableSet set];
    for (NSString *userId in userIds) {
        if ([self lookUpUserById:userId] == nil) {
            [uncached addObject:userId];
        }
    }
    if (uncached.count > 0) {
        AVQuery *query = [AVUser query];
        [query whereKey:@"objectId" containedIn:[uncached allObjects]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                block(NO, error);
            } else {
                for (AVUser *user in objects) {
                    [self addUserToCache:user];
                }
                block(YES, nil);
            }
        }];
    } else {
        block(YES, nil);
    }
}

-(NSArray*)getObjectIds:(NSArray*)avObjects{
    NSMutableArray* objectIds=[NSMutableArray array];
    for(AVObject* object in avObjects){
        [objectIds addObject:object.objectId];
    }
    return objectIds;
}

-(void)digOrCancelDigOfAlbum:(LCAlbum*)album block:(AVBooleanResultBlock)block{
    AVUser* user=[AVUser currentUser];
    if([album.digUsers containsObject:user]){
        [album removeObject:user forKey:KEY_DIG_USERS];
    }else{
        [album addObject:user forKey:KEY_DIG_USERS];
    }
    [album saveInBackgroundWithBlock:block];
}

-(void)commentToUser:(AVUser*)toUser AtAlbum:(LCAlbum*)album content:(NSString*)content block:(AVBooleanResultBlock)block{
    LZComment* comment=[LZComment object];
    comment.commentContent=content;
    AVUser* user=[AVUser currentUser];
    comment.commentUser=user;
    comment.album=album;
    comment.toUser=toUser;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            block(NO,error);
        }else{
            [album addObject:comment forKey:KEY_COMMENTS];
            [album saveInBackgroundWithBlock:block];
        }
    }];
}

- (BOOL)file:(AVObject *)file existsInAlbums:(NSArray *)albums {
    for (LCAlbum *album in albums) {
        for (AVFile *photo in album.albumPhotos) {
            if ([photo.objectId isEqualToString:file.objectId]) {
                return YES;
            }
        }
    }
    return NO;
}

// 数据维护，删掉没有出现在朋友圈里的文件
- (void)deleteUnusedFiles {
    AVQuery *query = [LCAlbum query];
    [query includeKey:KEY_ALBUM_PHOTOS];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *albums, NSError *error) {
        if (!error) {
            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
            [query orderByAscending:@"createdAt"];
            query.limit = 1000;
            [query findObjectsInBackgroundWithBlock:^(NSArray *files, NSError *error) {
                if (!error) {
                    NSMutableArray *toDeletes = [NSMutableArray array];
                    for (AVObject *file in files) {
                        if(![self file:file existsInAlbums:albums]) {
                            NSLog(@"file not exists will delete");
                            [toDeletes addObject:file];
                        } else {
                            NSLog(@"file exists do not delete");
                        };
                    }
                    [AVObject deleteAllInBackground:toDeletes block:^(BOOL succeeded, NSError *error) {
                        NSLog(@"deleted, error %@", error);
                    }];
                }
            }];
        }
    }];
}

@end
