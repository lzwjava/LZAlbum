//
//  MCAlbumTableViewCell.h
//  LZAlbum
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZAlbum.h"

@protocol LZAlbumTableViewCellDelegate <NSObject>

@optional

-(void)didCommentButtonClick:(UIButton*)button indexPath:(NSIndexPath*)indexPath;

-(void)didSelectCommentAtCellIndexPath:(NSIndexPath*)cellIndexPath commentIndexPath:(NSIndexPath*)commentIndexPath;

@end

@interface LZAlbumTableViewCell : UITableViewCell

@property (nonatomic,strong) LZAlbum* currentAlbum;

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,strong) id<LZAlbumTableViewCellDelegate> albumTableViewCellDelegate;

+(CGFloat)calculateCellHeightWithAlbum:(LZAlbum*)album;

@end
