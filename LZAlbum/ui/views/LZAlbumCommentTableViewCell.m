//
//  LZAlbumCommentTableViewCell.m
//  LZAlbum
//
//  Created by lzw on 15/8/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "LZAlbumCommentTableViewCell.h"

@interface LZAlbumCommentTableViewCell()<TTTAttributedLabelDelegate>

@property (nonatomic,strong) LZAlbumComment* albumComment;
@property (nonatomic,strong) TTTAttributedLabel* commentLabel;

@end

@implementation LZAlbumCommentTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(NSString*)textOfAlbumComment:(LZAlbumComment*)albumComment{
    if(albumComment==nil){
        return @"";
    }
    return [NSString stringWithFormat:@"%@ : %@",albumComment.fromUsername,albumComment.commentContent];
}

+(CGFloat)calculateCellHeightWithAlbumComment:(LZAlbumComment*)albumComment fixWidth:(CGFloat)width{
    if(albumComment==nil){
        return 0;
    }
    NSString* text=[albumComment fullCommentText];
    CGRect textRect=[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kLZAlbumFontSize]} context:nil];
    return textRect.size.height+kLZAlbumCommentLineSpacing;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect commentFrame=self.commentLabel.frame;
    commentFrame.size.height=[[self class] calculateCellHeightWithAlbumComment:_albumComment fixWidth:[LZAlbum contentWidth]];
    self.commentLabel.frame=commentFrame;
}

-(void)setupItem:(LZAlbumComment*)item atIndexPath:(NSIndexPath*)indexPath {
    _albumComment=item;
    NSRange fromUsernameRange = item.fromUsernameRange;
    NSRange toUsernameRange = item.toUsernameRange;
    NSString *fullCommentText = item.fullCommentText;
    if (fullCommentText.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullCommentText];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:fromUsernameRange];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:toUsernameRange];
        [self.commentLabel setText:attributedText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            return mutableAttributedString;
        }];
        if (fromUsernameRange.location != NSNotFound) {
            [self.commentLabel addLinkToURL:[NSURL URLWithString:item.fromUsername] withRange:fromUsernameRange];
        }
        if (toUsernameRange.location != NSNotFound) {
            [self.commentLabel addLinkToURL:[NSURL URLWithString:item.toUsername] withRange:toUsernameRange];
        }
    } else {
        self.commentLabel.text = nil;
    }
}

-(TTTAttributedLabel *)commentLabel{
    if(_commentLabel==nil){
        _commentLabel=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, [LZAlbum contentWidth], 10)];
        _commentLabel.font=[UIFont systemFontOfSize:kLZAlbumFontSize];
        _commentLabel.numberOfLines=0;
        _commentLabel.textColor = [UIColor darkGrayColor];
        _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _commentLabel.linkAttributes = @{(id)NSUnderlineStyleAttributeName:@(NO), (id)kCTForegroundColorAttributeName:(id)LZLinkTextForegroundColor.CGColor};
        _commentLabel.activeLinkAttributes = @{(id)kTTTBackgroundFillColorAttributeName:(id)LZLinkTextHighlightColor.CGColor};
        _commentLabel.delegate = self;
    }
    return _commentLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    DLog(@"%@ clicked", url.absoluteString);
}

- (void)prepareForReuse {
    self.commentLabel.text = nil;
}

@end
