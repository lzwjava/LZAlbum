//
//  MCUser.h
//  ClassNet
//
//  Created by lzw on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZCommon.h"

#define KEY_USERNAME @"username"
#define KEY_AVATAR @"avatar"

@interface AVUser(MCCustomUser)

-(AVFile*)avatar;

-(void)setAvatar:(AVFile*)avatar;

-(NSString*)avatarUrl;

@end
