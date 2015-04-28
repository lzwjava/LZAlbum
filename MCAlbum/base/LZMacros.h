//
//  MCMacros.h
//  ClassNet
//
//  Created by lzw on 15/3/26.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#ifndef ClassNet_MCMacros_h
#define ClassNet_MCMacros_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define WEAKSELF  typeof(self) __weak weakSelf=self;

#define RGB(R,G,B) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)/255]


#endif
