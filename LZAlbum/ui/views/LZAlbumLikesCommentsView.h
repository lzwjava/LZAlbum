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
static CGFloat kLZAlbumCommentIconHeight=16;

@protocol MCAlbumLikesCommentsViewDelegate <NSObject>

-(void)didSelectCommentAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface LZAlbumLikesCommentsView : UIView

@property (nonatomic,strong) id<MCAlbumLikesCommentsViewDelegate> albumLikesCommentsViewDelegate;

@property (nonatomic, strong) LZAlbum *album;

+ (BOOL)shouldShowLikesCommentsViewWithAlbum:(LZAlbum *)album;
+ (CGFloat)caculateLikesCommentsViewHeightWithAlbum:(LZAlbum*)album;

@end
