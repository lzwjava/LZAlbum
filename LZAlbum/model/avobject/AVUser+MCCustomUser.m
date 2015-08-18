//
//  MCUser.m
//  LZAlbum
//
//  Created by lzw on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "AVUser+MCCustomUser.h"

@implementation AVUser(MCCustomUser)

-(AVFile*)avatar{
    return [self objectForKey:KEY_AVATAR];
}

-(void)setAvatar:(AVFile*)avatar{
    [self setObject:avatar forKey:KEY_AVATAR];
}

-(NSString*)avatarUrl{
    return [self avatar].url;
}

@end