//
//  LoginForm.m
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "MCLoginForm.h"

@implementation MCLoginForm

-(NSArray*)extraFields{
    return @[@{FXFormFieldHeader:@"",FXFormFieldTitle:@"Login",FXFormFieldAction:@"submitLogin:"}];
}

@end
