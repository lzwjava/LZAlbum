//
//  MCAlbumReplyView.h
//  ClassNet
//
//  Created by lzw on 15/3/30.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat kLZAlbumReplyViewPadding=10;
static CGFloat kLZAlbumReplyViewHeight=44;

@class LZAlbumReplyView;

@protocol MCAlbumReplyViewDelegate <NSObject>

-(void)albumReplyView:(LZAlbumReplyView*)albumReplyView didReply:(NSString*)text;

@end

@interface LZAlbumReplyView : UIView

@property (nonatomic,strong) id<MCAlbumReplyViewDelegate> albumReplyViewDelegate;

-(void)show;

-(void)dismiss;

-(void)finishReply;

@end
