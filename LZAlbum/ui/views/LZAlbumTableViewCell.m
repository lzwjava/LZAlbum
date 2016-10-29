//
//  MCAlbumTableViewCell.m
//  LZAlbum
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumTableViewCell.h"


@interface LZAlbumTableViewCell ()<LZAlbumRichTextViewDelegate>



@end

@implementation LZAlbumTableViewCell

+(CGFloat)calculateCellHeightWithAlbum:(LZAlbum*)album{
    return [LZAlbumRichTextView calculateRichTextHeightWithAlbum:album];
}

- (void)awakeFromNib {
    // Initialization code
}

-(LZAlbumRichTextView*)albumRichTextView{
    if(_albumRichTextView==nil){
        _albumRichTextView=[[LZAlbumRichTextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 40)];
        _albumRichTextView.richTextViewDelegate=self;
    }
    _albumRichTextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    return _albumRichTextView;
}

-(void)setCurrentAlbum:(LZAlbum *)currentAlbum{
    _currentAlbum=currentAlbum;
    _albumRichTextView.album=currentAlbum;
}

-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.albumRichTextView];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

-(void)dealloc{
    _albumRichTextView=nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)didCommentButtonClick:(UIButton *)button{
    if([_albumTableViewCellDelegate respondsToSelector:@selector(didCommentButtonClick:indexPath:)]){
        [_albumTableViewCellDelegate didCommentButtonClick:button indexPath:self.indexPath];
    }
}

-(void)didSelectCommentAtIndexPath:(NSIndexPath *)indexPath{
    if([_albumTableViewCellDelegate respondsToSelector:@selector(didSelectCommentAtCellIndexPath:commentIndexPath:)]){
        [_albumTableViewCellDelegate didSelectCommentAtCellIndexPath:self.indexPath commentIndexPath:indexPath];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];    
    self.albumRichTextView.album = nil;
}

@end
