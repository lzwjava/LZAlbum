//
//  AsyncView.h
//  LearnObjective-C
//
//  Created by donghuan1 on 16/10/28.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncView : UIView
// 用于异步绘制的队列，为nil时将使用GCD的global queue进行绘制，默认为nil
@property (nonatomic, assign) dispatch_queue_t dispatchDrawQueue;

// 异步绘制时global queue的优先级，默认优先级为DEFAULT。在设置了drawQueue时此参数无效。
@property (nonatomic, assign) dispatch_queue_priority_t dispatchPriority;

- (BOOL)drawInRect:(CGRect)rect Context:(CGContextRef)context;

@end
