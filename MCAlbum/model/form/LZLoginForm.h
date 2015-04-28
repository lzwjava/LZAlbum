//
//  LoginForm.h
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZRegisterForm.h"
#import <FXForms/FXForms.h>

@interface LZLoginForm : NSObject<FXForm>

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;

@end
