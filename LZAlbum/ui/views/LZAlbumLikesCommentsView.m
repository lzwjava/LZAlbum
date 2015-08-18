//
//  MCAlbumLikesCommentsView.m
//  LZAlbum
//
//  Created by lzw on 15/3/28.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumLikesCommentsView.h"
#import "DWTagList.h"
#import "LZMacros.h"


@interface LZAlbumCommentTableViewCell ()

@property (nonatomic,strong) LZAlbumComment* albumComment;

@property (nonatomic,strong) UILabel* commentLabel;

@end

@implementation LZAlbumCommentTableViewCell

+(CGFloat)contentWidth{
    return CGRectGetWidth([[UIScreen mainScreen] bounds])-3*kLZAlbumAvatarSpacing-kLZAlbumAvatarImageSize;
}

+(NSString*)textOfAlbumComment:(LZAlbumComment*)albumComment{
    if(albumComment==nil){
        return @"";
    }
    return [NSString stringWithFormat:@"%@ : %@",albumComment.commentUsername,albumComment.commentContent];
}

+(CGFloat)calculateCellHeightWithAlbumComment:(LZAlbumComment*)albumComment fixWidth:(CGFloat)width{
    if(albumComment==nil){
        return 0;
    }
    NSString* text=[[self class] textOfAlbumComment:albumComment];
    CGRect textRect=[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kLZAlbumFontSize]} context:nil];
    return textRect.size.height+kLZAlbumCommentLineSpacing;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect commentFrame=self.commentLabel.frame;
    commentFrame.size.height=[[self class] calculateCellHeightWithAlbumComment:_albumComment fixWidth:[[self class] contentWidth]];
    self.commentLabel.frame=commentFrame;
}

-(void)setupItem:(LZAlbumComment*)item atIndexPath:(NSIndexPath*)indexPath{
    _albumComment=item;
    NSMutableAttributedString* text=[[NSMutableAttributedString alloc] initWithString:[[self class] textOfAlbumComment:item]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, item.commentUsername.length)];
    self.commentLabel.attributedText=text;
}

-(UILabel*)commentLabel{
    if(_commentLabel==nil){
        _commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[self class] contentWidth], 10)];
        _commentLabel.font=[UIFont systemFontOfSize:kLZAlbumFontSize];
        _commentLabel.numberOfLines=0;
    }
    return _commentLabel;
}

@end

static NSString* kLZAlbumCommentCellIndetifier=@"albumCommentCell";

@interface LZAlbumLikesCommentsView ()<UITableViewDataSource,UITableViewDelegate,DWTagListDelegate>

@property (nonatomic,strong) UIView *likeContainerView;
@property (nonatomic,strong) DWTagList* likesTagList;
@property (nonatomic,strong) UIImageView *likeIconView;
@property (nonatomic,strong) UITableView *commentTableView;

@end

@implementation LZAlbumLikesCommentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        self.backgroundColor=RGB(240, 245, 249);
        [self addSubview:self.likeContainerView];
        [self addSubview:self.commentTableView];
    }
    return self;
}

#pragma mark - Propertys

-(DWTagList*)likesTagList{
    if(_likesTagList==nil){
        _likesTagList=[[DWTagList alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeIconView.frame), CGRectGetMinY(self.likeIconView.frame), [LZAlbumCommentTableViewCell contentWidth]-CGRectGetWidth(self.likeIconView.frame), kLZAlbumLikeViewHeight)];
        _likesTagList.automaticResize=NO;
        _likesTagList.font=[UIFont systemFontOfSize:kLZAlbumFontSize];
        _likesTagList.textColor=[UIColor blueColor];
        _likesTagList.horizontalPadding=0;
        _likesTagList.labelMargin=0;
        _likesTagList.verticalPadding=1;
        [_likesTagList setTagDelegate:self];
        [_likesTagList setTagBackgroundColor:[UIColor clearColor]];
        _likesTagList.cornerRadius=0;
        _likesTagList.borderWidth=0;
    }
    return _likesTagList;
}

-(UIView*)likeContainerView{
    if(_likeContainerView==nil){
        _likeContainerView=[[UIView alloc] initWithFrame:CGRectZero];
        _likeContainerView.autoresizesSubviews=YES;
        [_likeContainerView addSubview:self.likeIconView];
        [_likeContainerView addSubview:self.likesTagList];
    }
    return _likeContainerView;
}

-(UIImageView*)likeIconView{
    if(_likeIconView==nil){
        _likeIconView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLZAlbumCommentCellHeight, kLZAlbumCommentCellHeight)];
        _likeIconView.image=[UIImage imageNamed:@"AlbumInformationLikeHL"];
    }
    return _likeIconView;
}

-(UITableView*)commentTableView{
    if(_commentTableView==nil){
        _commentTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commentTableView.separatorColor=[UIColor clearColor];
        _commentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_commentTableView registerClass:[LZAlbumCommentTableViewCell class] forCellReuseIdentifier:kLZAlbumCommentCellIndetifier];
        _commentTableView.dataSource=self;
        _commentTableView.delegate=self;
        _commentTableView.scrollEnabled=NO;
        _commentTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _commentTableView.backgroundColor=[UIColor clearColor];
    }
    return _commentTableView;
}

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex{
    DLog();
}

-(void)reloadLikes{
    NSMutableArray* likeTexts=[NSMutableArray array];
    for(int i=0;i<_likes.count;i++){
        [likeTexts addObject:[NSString stringWithFormat:@"%@%@",i==0? @"":@", ",_likes[i]]];
    }
    [_likesTagList setTags:likeTexts];
}

-(void)updateUserInterface{
    BOOL shouldShowLike=self.likes.count>0;
    BOOL shouldShowComment=self.comments.count>0;
    
    if(!shouldShowLike && !shouldShowComment){
        self.frame=CGRectZero;
        return;
    }
    
    if(shouldShowLike){
        CGRect likeContainerFrame=self.likeContainerView.frame;
        likeContainerFrame.size=CGSizeMake(CGRectGetWidth(self.bounds), kLZAlbumLikeViewHeight);
        self.likeContainerView.frame=likeContainerFrame;
        self.likeContainerView.hidden=NO;
    }else{
        self.likeContainerView.hidden=YES;
    }
    if(shouldShowComment){
        CGRect commentTableFrame=self.commentTableView.frame;
        commentTableFrame.origin.y=CGRectGetMaxY(self.likeContainerView.frame);
        self.commentTableView.frame=commentTableFrame;
    }
    
    CGRect frame=self.frame;
    frame.size.height=CGRectGetMaxY(shouldShowComment? self.commentTableView.frame:self.likeContainerView.frame);
    self.frame=frame;
}

-(void)reloadData{
    [self.commentTableView reloadData];
    [self reloadLikes];
    [self updateUserInterface];
}

#pragma mark - UITablView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comments.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZAlbumCommentTableViewCell* commentCell=[tableView dequeueReusableCellWithIdentifier:kLZAlbumCommentCellIndetifier forIndexPath:indexPath];
    if(commentCell==nil){
        commentCell=[[LZAlbumCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLZAlbumCommentCellIndetifier];
    }
    LZAlbumComment* albumComment=_comments[indexPath.row];
    [commentCell setupItem:albumComment atIndexPath:indexPath];
    return commentCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZAlbumComment* albumComment=_comments[indexPath.row];
    CGFloat cellHeight=[LZAlbumCommentTableViewCell calculateCellHeightWithAlbumComment:albumComment fixWidth:[LZAlbumCommentTableViewCell contentWidth]];
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.albumLikesCommentsViewDelegate respondsToSelector:@selector(didSelectCommentAtIndexPath:)]){
        [self.albumLikesCommentsViewDelegate didSelectCommentAtIndexPath:indexPath];
    }
}

@end
