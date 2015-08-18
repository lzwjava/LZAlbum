//
//  MCViewController.m
//  LZAlbum
//
//  Created by lzw on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZBaseVC.h"

@interface LZBaseVC ()

@end

@implementation LZBaseVC

-(void)alert:(NSString*)msg{
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil message:msg delegate:nil
                            cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

-(BOOL)alertError:(NSError*)error{
    if(error){
        [self alert:[NSString stringWithFormat:@"%@",error]];
        return YES;
    }
    return NO;
}

-(BOOL)filterError:(NSError*)error{
    return [self alertError:error]==NO;
}

-(void)showNetworkIndicator{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

-(void)hideNetworkIndicator{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}

-(void)showProgress{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)showHUDText:(NSString*)text{
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=text;
    hud.margin=10.f;
    hud.removeFromSuperViewOnHide=YES;
    hud.mode=MBProgressHUDModeText;
    [hud hide:YES afterDelay:2];
}

-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

-(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
