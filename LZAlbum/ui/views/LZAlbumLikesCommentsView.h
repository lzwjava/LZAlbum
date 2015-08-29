//
//  MCAlbumLikesCommentsView.h
//  LZAlbum
//
//  Created by lzw on 15/3/28.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZAlbum.h"

static CGFloat kLZAlbumCommentCellUsernameWidth=22;
static CGFloat kLZAlbumLikeViewHeight=18;
static CGFloat kLZAlbumCommentCellHeight=16;

@protocol MCAlbumLikesCommentsViewDelegate <NSObject>

-(void)didSelectCommentAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface LZAlbumLikesCommentsView : UIView

@property (nonatomic,strong) id<MCAlbumLikesCommentsViewDelegate> albumLikesCommentsViewDelegate;

@property (nonatomic,strong) NSArray *likes;

@property (nonatomic,strong) NSArray *comments;

-(void)reloadData;

@end
