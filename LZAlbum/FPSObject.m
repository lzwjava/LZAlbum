//
//  FPSObject.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/19.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "FPSObject.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "JDStatusBarNotification.h"
@interface FPSObject()
{
    //定时器
    CADisplayLink *linkTimer;
    
    //用于计算平均值的数组
    CFTimeInterval *fpsBuffer;
    //用于计算平均值的数组大小
    int fpsBufferSize;
    
    //计算一次fps的间隔
    int refreshSeconds;
    //计算一次fps间隔用的临时变量
    int refreshCounter;
    int count;
    //用于记录上一次的时间戳
    CFTimeInterval lastTimeStamp;
    
    //
    NSInteger currentSeconds;
    NSInteger currentCount;
    
    UILabel *showFPs;
}
@end

@implementation FPSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        linkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        
        fpsBufferSize = 10;
        fpsBuffer = malloc(sizeof(CFTimeInterval)*fpsBufferSize);
        fpsBufferSize -= 1;
        refreshSeconds = 10;
        refreshCounter = 0;
        
        lastTimeStamp = CFAbsoluteTimeGetCurrent();
        //添加到当前runloop中
        [linkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        showFPs = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 150, 40)];
        showFPs.textColor = [UIColor whiteColor];
        showFPs.font = [UIFont systemFontOfSize:12];
        showFPs.text = @"0";
//        [[UIApplication sharedApplication].delegate.window addSubview:showFPs];
        
        
        
    }
    return self;
}

/**
 * @brief 带字符串参数的方法.

 */
- (void)update:(CADisplayLink *)timer
{
    count ++;
    if (count >200) {
        count = 1;
    }


        for (int i = fpsBufferSize - 1; i > 0; i--) {
            fpsBuffer[i] = fpsBuffer[i-1];
        }
        fpsBuffer[0] = timer.timestamp - lastTimeStamp;
        lastTimeStamp = timer.timestamp;
    
        double maxTime = 0;
        double averTimeSum = 0;
        double averTime = 0;
    
        for (int i = 0; i < fpsBufferSize; i++)
        {
            maxTime = MAX(fpsBuffer[i],maxTime);
            averTimeSum += fpsBuffer[i];
        }
    
        averTime = averTimeSum / fpsBufferSize;
    
        refreshCounter ++;
    
        if (refreshCounter%refreshSeconds == 0) {
            refreshCounter = 0;
            NSString *info = [NSString stringWithFormat:@"current:%.1f---aver:%.1f",roundf(1.f/maxTime),round(1.f/averTime)];
            [JDStatusBarNotification showWithStatus:info styleName:JDStatusBarStyleDark];
            
        }
    
    
}

@end
