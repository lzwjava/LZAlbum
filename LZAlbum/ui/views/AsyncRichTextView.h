//
//  AsyncRichTextView.h
//  LZAlbum
//
//  Created by liudonghuan on 16/10/27.
//  Copyright © 2016年 lzw. All rights reserved.
//

#import "AsyncView.h"
#import <CoreText/CoreText.h>
#import "LZAlbum.h"
@protocol LZAlbumRichTextViewDelegate <NSObject>

-(void)didCommentButtonClick:(UIButton*)button;

-(void)didSelectCommentAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface AsyncRichTextView : AsyncView
@property (nonatomic,strong)LZAlbum *album;
@property (nonatomic,weak) id<LZAlbumRichTextViewDelegate> richTextViewDelegate;
- (instancetype)initWithFrame:(CGRect)frame Album:(LZAlbum *)album;
@end
