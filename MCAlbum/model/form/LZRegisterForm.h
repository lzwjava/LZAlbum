//
//  RegisterForm.h
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXForms/FXForms.h>

@interface LZRegisterForm : NSObject<FXForm>

@property (nonatomic,strong) UIImage *avatar;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;

@end
