//
//  MCFeed.m
//  ClassNet
//
//  Created by wangyuansong on 15/3/11.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LCAlbum.h"

@implementation LCAlbum

@dynamic creator;
@dynamic albumContent;
@dynamic albumPhotos;
@dynamic comments;
@dynamic digUsers;
@dynamic isDel;

+(NSString*)parseClassName{
    return @"Album";
}

@end
