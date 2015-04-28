//
//  MCAlbumTableViewCell.h
//  ClassNet
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAlbum.h"

@protocol MCAlbumTableViewCellDelegate <NSObject>

@optional

-(void)didCommentButtonClick:(UIButton*)button indexPath:(NSIndexPath*)indexPath;

-(void)didSelectCommentAtCellIndexPath:(NSIndexPath*)cellIndexPath commentIndexPath:(NSIndexPath*)commentIndexPath;

@end

@interface MCAlbumTableViewCell : UITableViewCell

@property (nonatomic,strong) MCAlbum* currentAlbum;

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,strong) id<MCAlbumTableViewCellDelegate> albumTableViewCellDelegate;

+(CGFloat)calculateCellHeightWithAlbum:(MCAlbum*)album;

@end
