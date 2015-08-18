//
//  MCFeedManager.m
//  LZAlbum
//
//  Created by lzw on 15/4/1.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumManager.h"

@implementation LZAlbumManager

+(LZAlbumManager*)manager{
    static LZAlbumManager* albumManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        albumManager=[[LZAlbumManager alloc] init];
    });
    return albumManager;
}

-(void)createAlbumWithText:(NSString*)text photos:(NSArray*)photos error:(NSError**)error{
    if(text==nil){
        text=@"";
    }
    NSMutableArray* photoFiles=[NSMutableArray array];
    NSError* theError;
    for(UIImage* photo in photos){
        AVFile* photoFile=[AVFile fileWithData:UIImageJPEGRepresentation(photo, 0.6)];
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
    // 同时保存了 photoFiles
    [album save:&theError];
    *error=theError;
}

-(void)findAlbumWithBlock:(AVArrayResultBlock)block{
    AVQuery* q=[LCAlbum query];
    [q orderByDescending:KEY_CREATED_AT];
    [q includeKey:KEY_ALBUM_PHOTOS];
    [q includeKey:KEY_DIG_USERS];
    [q includeKey:KEY_CREATOR];
    [q includeKey:@"comments.commentUser"];
    [q includeKey:@"comments.toUser"];
    [q setLimit:50];
    [q whereKey:KEY_IS_DEL equalTo:@(NO)];
    [q setCachePolicy:kAVCachePolicyNetworkElseCache];
    [q findObjectsInBackgroundWithBlock:block];
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
    comment.commentUsername=user.username;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            block(NO,error);
        }else{
            [album addObject:comment forKey:KEY_COMMENTS];
            [album saveInBackgroundWithBlock:block];
        }
    }];
}

@end
