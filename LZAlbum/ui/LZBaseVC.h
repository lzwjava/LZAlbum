//
//  MCViewController.h
//  LZAlbum
//
//  Created by lzw on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZMacros.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LZBaseVC : UIViewController

-(void)showNetworkIndicator;

-(void)hideNetworkIndicator;

-(void)showProgress;

-(void)hideProgress;

-(void)alert:(NSString*)msg;

-(BOOL)alertError:(NSError*)error;

-(BOOL)filterError:(NSError*)error;

-(void)runInMainQueue:(void (^)())queue;

-(void)runInGlobalQueue:(void (^)())queue;

-(void)runAfterSecs:(float)secs block:(void (^)())block;

-(void)showHUDText:(NSString*)text;

@end
