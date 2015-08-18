//
//  MCComment.m
//  LZAlbum
//
//  Created by wangyuansong on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZComment.h"

@implementation LZComment

@dynamic album;
@dynamic commentContent;
@dynamic commentUsername;
@dynamic commentUser;
@dynamic toUser;

+(NSString*)parseClassName{
    return @"Comment";
}

@end
