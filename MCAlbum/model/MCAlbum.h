//
//  MCAlbum.h
//  ClassNet
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kMCAlbumAvatarSpacing=15.0f;
static const CGFloat kMCAlbumAvatarImageSize=45.0f;

static const CGFloat kMCAlbumPhotoSize=70;
static const CGFloat kMCAlbumPhotoInset=5;

static const CGFloat kMCAlbumFontSize=15;

@interface MCAlbumComment : NSObject

@property (nonatomic,copy) NSString* commentUsername;

@property (nonatomic,copy) NSString* commentContent;

@end

@interface MCAlbum : NSObject

@property (nonatomic,copy) NSString* username;

@property (nonatomic,copy) NSString* avatarUrl;

@property (nonatomic,copy) NSString* albumShareContent;

@property (nonatomic,strong) NSArray* albumSharePhotos;

@property (nonatomic,strong) NSArray* albumShareLikes;

@property (nonatomic,strong) NSArray* albumShareComments;

@property (nonatomic,copy) NSDate* albumShareTimestamp;

@end
