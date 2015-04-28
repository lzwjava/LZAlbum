//
//  AppDelegate.m
//  MCAlbum
//
//  Created by lzw on 15/4/28.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "AppDelegate.h"
#import "LCAlbum.h"
#import "MCComment.h"
#import "MCEntryFormController.h"
#import "MCAlbumVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LCAlbum registerSubclass];
    [MCComment registerSubclass];
    [AVOSCloud setApplicationId:@"0y463z4tk9wk4zbtkq4qn21kshdm9zetj8mkouiqkaoovn4e" clientKey:@"j9de7xoza1gbvkbp0b6qudz10s9lkwsxqll2nvwrjfty3a58"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
#ifdef DEBUG
    [AVAnalytics setAnalyticsEnabled:NO];
    [AVAnalytics setCrashReportEnabled:NO];
    [AVOSCloud setVerbosePolicy:kAVVerboseShow];
    [AVLogger addLoggerDomain:AVLoggerDomainIM];
    [AVLogger addLoggerDomain:AVLoggerDomainCURL];
    [AVLogger setLoggerLevelMask:AVLoggerLevelAll];
#endif
    
    UIColor* tintColor=[UIColor colorWithRed:0.071 green:0.060 blue:0.086 alpha:1.000];
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
        [UINavigationBar appearance].barTintColor=tintColor;
        [UINavigationBar appearance].tintColor=[UIColor whiteColor];
    }else{
        [UINavigationBar appearance].tintColor=tintColor;
    }
    [UINavigationBar appearance].titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController* nextVC;
    if([AVUser currentUser]){
        nextVC=[[MCAlbumVC alloc] init];
    }else{
        nextVC=[[MCEntryFormController alloc] init];
    }
    self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:nextVC];
    return YES;
}

-(void)toMain{
    MCAlbumVC* vc=[[MCAlbumVC alloc] init];
    self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
