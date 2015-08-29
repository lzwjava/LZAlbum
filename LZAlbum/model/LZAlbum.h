//
//  LZAlbum.h
//  LZAlbum
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZAlbumComment.h"
#import "LZMacros.h"

#define LZLinkTextForegroundColor RGB(117, 135, 181)
#define LZLinkTextHighlightColor [UIColor colorWithWhite:0.7 alpha:1]

static const CGFloat kLZAlbumAvatarSpacing=15.0f;
static const CGFloat kLZAlbumAvatarImageSize=45.0f;

static const CGFloat kLZAlbumPhotoSize=70;
static const CGFloat kLZAlbumPhotoInset=5;

static const CGFloat kLZAlbumFontSize=15;

@interface LZPhoto : NSObject

@property (nonatomic, copy) NSString *thumbnailUrl;

@property (nonatomic, copy) NSString *originUrl;

+ (instancetype)photoWithOriginUrl:(NSString *)originUrl thumbnailUrl:(NSString *)thumbnailUrl;

- (NSString *)actualThumbnailUrl;

@end

@interface LZAlbum : NSObject

@property (nonatomic,copy) NSString* username;

@property (nonatomic,copy) NSString* avatarUrl;

@property (nonatomic,copy) NSString* albumShareContent;

@property (nonatomic,strong) NSArray* albumSharePhotos;

@property (nonatomic,strong) NSArray* albumShareLikes;

@property (nonatomic,strong) NSArray* albumShareComments;

@property (nonatomic,copy) NSDate* albumShareTimestamp;

@end
