//
//  MCAlbumOperationView.h
//  ClassNet
//
//  Created by lzw on 15/3/28.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    MCAlbumOperationTypeLike=0,
    MCAlbumOperationTypeReply
}MCAlbumOperationType;

static CGFloat kMCAlbumOperationViewWidth=120;
static CGFloat kMCAlbumOperationViewHeight=34;

@class MCAlbumOperationView;


@protocol MCAlbumOperationViewDelegate <NSObject>

@optional

-(void)albumOperationView:(MCAlbumOperationView*)albumOperationView didClickOfType:(MCAlbumOperationType)operationType;

@end

@interface MCAlbumOperationView : UIView

@property (nonatomic,strong) id<MCAlbumOperationViewDelegate> albumOperationViewDelegate;

@property (nonatomic,assign) BOOL shouldShowed;

+(instancetype)initialOperationView;

-(void)showAtView:(UIView*)containerView rect:(CGRect)targetRect;

-(void)dismiss;

@end
