//
//  LZAlbumCommentTableViewCell.h
//  LZAlbum
//
//  Created by lzw on 15/8/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZAlbum.h"

static CGFloat kLZAlbumCommentLineSpacing=3;

@interface LZAlbumCommentTableViewCell : UITableViewCell

+(CGFloat)contentWidth;
+(CGFloat)calculateCellHeightWithAlbumComment:(LZAlbumComment*)albumComment fixWidth:(CGFloat)width;

-(void)setupItem:(LZAlbumComment*)item atIndexPath:(NSIndexPath*)indexPath;

@end
