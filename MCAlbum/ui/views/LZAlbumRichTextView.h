//
//  MCAlbumRichTextView.h
//  ClassNet
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZAlbum.h"
#import "LZAlbumLikesCommentsView.h"

static const CGFloat kLZAlbumUsernameHeight=18.0f;
static const CGFloat kLZAlbumContentLineSpacing=4.0f;
static const CGFloat kLZAlbumCommentButtonWidth=25.0f;
static const CGFloat kLZAlbumCommentButtonHeight=25.0f;

@protocol LZAlbumRichTextViewDelegate <NSObject>

-(void)didCommentButtonClick:(UIButton*)button;

-(void)didSelectCommentAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface LZAlbumRichTextView : UIView

@property (nonatomic,strong) LZAlbum* album;

@property (nonatomic,strong) id<LZAlbumRichTextViewDelegate> richTextViewDelegate;

+(CGFloat)calculateRichTextHeightWithAlbum:(LZAlbum*)album;


@end
