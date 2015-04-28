//
//  MCAlbumReplyView.h
//  ClassNet
//
//  Created by lzw on 15/3/30.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat kMCAlbumReplyViewPadding=10;
static CGFloat kMCAlbumReplyViewHeight=44;

@class MCAlbumReplyView;

@protocol MCAlbumReplyViewDelegate <NSObject>

-(void)albumReplyView:(MCAlbumReplyView*)albumReplyView didReply:(NSString*)text;

@end

@interface MCAlbumReplyView : UIView

@property (nonatomic,strong) id<MCAlbumReplyViewDelegate> albumReplyViewDelegate;

-(void)show;

-(void)dismiss;

-(void)finishReply;

@end
