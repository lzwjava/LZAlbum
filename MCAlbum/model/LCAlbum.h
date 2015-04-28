//
//  MCFeed.h
//  ClassNet
//
//  Created by wangyuansong on 15/3/11.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "MCAVObjectHeader.h"

#define KEY_CLS @"cls"
#define KEY_ALBUM_TYPE @"albumType"
#define KEY_ALBUM_CONTENT @"albumContent"
#define KEY_ALBUM_PHOTOS @"albumPhotos"
#define KEY_DIG_USERS @"digUsers"
#define KEY_COMMENTS @"comments"
#define KEY_IS_DEL @"isDel"
#define KEY_CREATOR @"creator"

@interface LCAlbum : AVObject<AVSubclassing>

@property (nonatomic,strong) AVUser* creator; // 创建者
@property (nonatomic,copy) NSString* albumContent; //分享内容
@property (nonatomic,assign) NSArray* albumPhotos;  //分享照片 _File Array
@property (nonatomic,assign) NSArray* digUsers; //赞过的人 _User Array
@property (nonatomic,assign) NSArray* comments; // Comment Array
@property (nonatomic,assign) BOOL isDel; //是否删除

// createdAt : 发布时间

@end
