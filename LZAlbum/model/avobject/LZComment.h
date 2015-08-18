//
//  MCComment.h
//  LZAlbum
//
//  Created by wangyuansong on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZCommon.h"
#import "LCAlbum.h"

#define KEY_ALBUM @"album"
#define KEY_COMMENT_USER @"commentUser"
#define KEY_COMMENT_USERNAME @"commentUsername"
#define KEY_COMMENT_CONTENT @"commentContent"
#define KEY_TO_USER @"toUser"

@interface LZComment : AVObject<AVSubclassing>

@property (nonatomic,strong) LCAlbum* album;//关联分享
@property (nonatomic,strong) NSString* commentUsername;
@property (nonatomic,strong) AVUser* commentUser;//评论用户
@property (nonatomic,strong) NSString* commentContent;//评论内容
@property (nonatomic,strong)AVUser* toUser;//关联用户

// createdAt:评论时间

@end
