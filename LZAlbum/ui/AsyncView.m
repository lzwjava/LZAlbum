//
//  AsyncView.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/4.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "AsyncView.h"

@implementation AsyncView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        self.opaque = NO;
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (!self.window)
    {
        // 没有 Window 说明View已经没有显示在界面上，此时应该终止绘制
        
    }
    else if (!self.layer.contents)
    {
        [self.layer setNeedsDisplay];
    }
}

- (dispatch_queue_t)drawQueue
{
    if (self.dispatchDrawQueue)
    {
        return self.dispatchDrawQueue;
    }
    
    return dispatch_get_global_queue(self.dispatchPriority, 0);
}

- (void)displayLayer:(CALayer *)layer
{
    
    dispatch_async([self drawQueue], ^{
        [self displayLayer:layer Rect:layer.frame];
    });
}

- (BOOL)drawInRect:(CGRect)rect Context:(CGContextRef)context
{
    return YES;
}

- (void)displayLayer:(CALayer *)layer Rect:(CGRect)rect
{
    CGContextRef context = NULL;
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, layer.contentsScale);
    context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (rect.origin.x || rect.origin.y)
    {
        CGContextTranslateCTM(context, rect.origin.x, -rect.origin.y);
    }
    
    if (self.backgroundColor &&
        self.backgroundColor != [UIColor clearColor])
    {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, rect);
    }
    [self drawInRect:rect Context:context];
    CGContextRestoreGState(context);
    
    if(true)//所有绘制完成
    {
        CGImageRef CGImage = context ? CGBitmapContextCreateImage(context) : nil;
        
        UIImage *image = CGImage ? [UIImage imageWithCGImage:CGImage] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            layer.contents = (id)image.CGImage;
        });
    }
    
}




@end
