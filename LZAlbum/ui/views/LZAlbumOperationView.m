//
//  MCAlbumOperationView.m
//  ClassNet
//
//  Created by lzw on 15/3/28.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumOperationView.h"

@interface LZAlbumOperationView ()

@property (nonatomic,strong) UIButton* likeButton;
@property (nonatomic,strong) UIButton* replyButton;
@property (nonatomic,assign) CGRect targetRect;

@end

@implementation LZAlbumOperationView

+(instancetype)initialOperationView{
    LZAlbumOperationView* operationView=[[LZAlbumOperationView alloc] initWithFrame:CGRectZero];
    return operationView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.8];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        [self addSubview:self.likeButton];
        [self addSubview:self.replyButton];
    }
    return self;
}

-(UIButton*)likeButton{
    if(_likeButton==nil){
        _likeButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLZAlbumOperationViewWidth/2, kLZAlbumOperationViewHeight)];
        _likeButton.tag=MCAlbumOperationTypeLike;
        _likeButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_likeButton addTarget:self action:@selector(operationViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

-(UIButton*)replyButton{
    if(_replyButton==nil){
        _replyButton=[[UIButton alloc] initWithFrame:CGRectMake(kLZAlbumOperationViewWidth/2, 0, kLZAlbumOperationViewWidth/2, kLZAlbumOperationViewHeight)];
        _replyButton.tag=MCAlbumOperationTypeReply;
        _replyButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_replyButton addTarget:self action:@selector(operationViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyButton;
}

-(void)operationViewDidClick:(UIButton*)sender{
    if([_albumOperationViewDelegate respondsToSelector:@selector(albumOperationView:didClickOfType:)]){
        [_albumOperationViewDelegate albumOperationView:self didClickOfType:sender.tag];
    }
}

-(void)showAtView:(UIView*)containerView rect:(CGRect)targetRect{
    if(_shouldShowed){
        return;
    }
    _shouldShowed=YES;
    self.targetRect=targetRect;
    [containerView addSubview:self];
    
    self.frame=CGRectMake(targetRect.origin.x, targetRect.origin.y, 0, kLZAlbumOperationViewHeight);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame=CGRectMake(targetRect.origin.x-kLZAlbumOperationViewWidth, targetRect.origin.y, kLZAlbumOperationViewWidth, kLZAlbumOperationViewHeight);
    } completion:^(BOOL finished) {
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [_replyButton setTitle:@"评论" forState:UIControlStateNormal];
    }];
}

-(void)dismiss{
    if(self.shouldShowed==NO){
        return;
    }
    self.shouldShowed=NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame=CGRectMake(_targetRect.origin.x, _targetRect.origin.y, 0, kLZAlbumOperationViewHeight);
    } completion:^(BOOL finished) {
        [_likeButton setTitle:nil forState:UIControlStateNormal];
        [_replyButton setTitle:nil forState:UIControlStateNormal];
        [self removeFromSuperview];
    }];
}

@end
