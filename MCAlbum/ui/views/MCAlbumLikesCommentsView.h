//
//  MCAlbumLikesCommentsView.h
//  ClassNet
//
//  Created by lzw on 15/3/28.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAlbum.h"

static CGFloat kMCAlbumCommentCellUsernameWidth=22;
static CGFloat kMCAlbumLikeViewHeight=18;
static CGFloat kMCAlbumCommentCellHeight=16;
static CGFloat kMCAlbumCommentLineSpacing=3;

@protocol MCAlbumLikesCommentsViewDelegate <NSObject>

-(void)didSelectCommentAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface MCAlbumCommentTableViewCell : UITableViewCell

+(CGFloat)calculateCellHeightWithAlbumComment:(MCAlbumComment*)albumComment fixWidth:(CGFloat)width;

@end

@interface MCAlbumLikesCommentsView : UIView

@property (nonatomic,strong) id<MCAlbumLikesCommentsViewDelegate> albumLikesCommentsViewDelegate;

@property (nonatomic,strong) NSArray *likes;

@property (nonatomic,strong) NSArray *comments;

-(void)reloadData;

@end
