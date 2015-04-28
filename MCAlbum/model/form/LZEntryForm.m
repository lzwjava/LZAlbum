//
//  MCRootForm.m
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZEntryForm.h"

@implementation LZEntryForm

-(NSDictionary*)loginFormField{
    return @{FXFormFieldInline:@YES,FXFormFieldHeader:@"Login"};
}

-(NSDictionary*)registerFormField{
    return @{FXFormFieldHeader:@"Not Registered?",FXFormFieldTitle:@"Register"};
}

@end
