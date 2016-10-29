//
//  FPSObject.h
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/19.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPSObject : NSObject
@end

/**
  CADisplayLink
  A CADisplayLink object is a timer object that allows your application to synchronize its drawing to the refresh rate of the display.
  CADisplayLink是一种定时器，系统的每一帧刷新时都会被调用。
 
  CADisplayLink中的timestamp是系统每次调用时的系统时间戳，通过计算两次时间戳的间隔，可以得到每一帧所花费的时间，既可以获取当前每秒能刷新多少帧。
 */
