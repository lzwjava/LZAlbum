//
//  RegisterForm.m
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "MCRegisterForm.h"

@implementation MCRegisterForm

-(NSArray*)extraFields{
    return @[@{FXFormFieldHeader:@"",FXFormFieldTitle:@"Register",FXFormFieldAction:@"submitRegister:"}];
}

@end
