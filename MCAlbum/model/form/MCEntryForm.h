//
//  MCRootForm.h
//  MCAlbum
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCLoginForm.h"
#import "MCRegisterForm.h"

@interface MCEntryForm : NSObject<FXForm>

@property (nonatomic,strong) MCLoginForm *loginForm;
@property (nonatomic,strong) MCRegisterForm *registerForm;

@end
