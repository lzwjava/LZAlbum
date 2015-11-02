//
//  LZInputAccessoryView.m
//  LZAlbum
//
//  Created by lzw on 15/10/1.
//  Copyright © 2015年 lzw. All rights reserved.
//

#define SLK_IS_IOS9_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#import "LZInputAccessoryView.h"

@implementation LZInputAccessoryView


#pragma mark - Super Overrides

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        if (SLK_IS_IOS9_AND_HIGHER) {
            
            NSPredicate *windowPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", NSClassFromString(@"UIRemoteKeyboardWindow")];
            UIWindow *keyboardWindow = [[[UIApplication sharedApplication].windows filteredArrayUsingPredicate:windowPredicate] firstObject];
            
            for (UIView *subview in keyboardWindow.subviews) {
                for (UIView *hostview in subview.subviews) {
                    if ([hostview isMemberOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                        _keyboardViewProxy = hostview;
                        break;
                    }
                }
            }
        }
        else {
            _keyboardViewProxy = newSuperview;
        }
    }
}



@end
