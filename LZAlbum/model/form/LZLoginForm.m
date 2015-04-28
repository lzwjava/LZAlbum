//
//  LoginForm.m
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZLoginForm.h"

@implementation LZLoginForm

-(NSArray*)extraFields{
    return @[@{FXFormFieldHeader:@"",FXFormFieldTitle:@"Login",FXFormFieldAction:@"submitLogin:"}];
}

@end
