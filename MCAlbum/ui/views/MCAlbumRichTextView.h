//
//  MCAlbumRichTextView.h
//  ClassNet
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAlbum.h"
#import "MCAlbumLikesCommentsView.h"

static const CGFloat kMCAlbumUsernameHeight=18.0f;
static const CGFloat kMCAlbumContentLineSpacing=4.0f;
static const CGFloat kMCAlbumCommentButtonWidth=25.0f;
static const CGFloat kMCAlbumCommentButtonHeight=25.0f;

@protocol MCAlbumRichTextViewDelegate <NSObject>

-(void)didCommentButtonClick:(UIButton*)button;

-(void)didSelectCommentAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface MCAlbumRichTextView : UIView

@property (nonatomic,strong) MCAlbum* album;

@property (nonatomic,strong) id<MCAlbumRichTextViewDelegate> richTextViewDelegate;

+(CGFloat)calculateRichTextHeightWithAlbum:(MCAlbum*)album;


@end
