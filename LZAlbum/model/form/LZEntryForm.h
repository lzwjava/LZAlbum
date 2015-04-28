//
//  MCRootForm.h
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZLoginForm.h"
#import "LZRegisterForm.h"

@interface LZEntryForm : NSObject<FXForm>

@property (nonatomic,strong) LZLoginForm *loginForm;
@property (nonatomic,strong) LZRegisterForm *registerForm;

@end
