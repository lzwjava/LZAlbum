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
#import "LZAlbumCommentTableViewCell.h"

static NSString* kLZAlbumCommentCellIndetifier=@"albumCommentCell";

@interface LZAlbumLikesCommentsView ()<UITableViewDataSource,UITableViewDelegate,DWTagListDelegate>

@property (nonatomic,strong) UIView *likeContainerView;
@property (nonatomic,strong) DWTagList* likesTagList;
@property (nonatomic,strong) UIImageView *likeIconView;
@property (nonatomic,strong) UITableView *commentTableView;

@end

@implementation LZAlbumLikesCommentsView

+ (BOOL)shouldShowLikesViewWithAlbum:(LZAlbum *)album {
    return album.albumShareLikes.count > 0;
}

+ (BOOL)shouldShowCommentsViewWithAlbum:(LZAlbum *)album {
    return album.albumShareComments.count > 0;
}

+ (BOOL)shouldShowLikesCommentsViewWithAlbum:(LZAlbum *)album {
    return [self shouldShowLikesViewWithAlbum:album] | [self shouldShowCommentsViewWithAlbum:album];
}

+ (CGFloat)caculateLikesViewHeightWithAlbum:(LZAlbum *)album {
    if (![self shouldShowLikesViewWithAlbum:album]) {
        return 0;
    }
    DWTagList *mockTagList = [[DWTagList alloc] initWithFrame:CGRectMake(0, 0, [LZAlbum contentWidth], 0)];
    [[self class] customLikesTagList:mockTagList];
    [[self class] reloadLikesWithAlbum:album tagList:mockTagList];
    return [mockTagList fittedSize].height;
}

+ (CGFloat)caculateCommentsViewHeightWithAlbum:(LZAlbum *)album {
    CGFloat fixWidth=[LZAlbum contentWidth];
    CGFloat commentsHeight=0;
    for(LZAlbumComment* albumComment in album.albumShareComments){
        commentsHeight+=[LZAlbumCommentTableViewCell calculateCellHeightWithAlbumComment:albumComment fixWidth:fixWidth];
    }
    return commentsHeight;
}

+ (CGFloat)caculateLikesCommentsViewHeightWithAlbum:(LZAlbum*)album {
    CGFloat height=0;
    if ([self shouldShowLikesViewWithAlbum:album]) {
        height += [self caculateLikesViewHeightWithAlbum:album];
    }
    if([self shouldShowCommentsViewWithAlbum:album]){
        height += [self caculateCommentsViewHeightWithAlbum:album];
    }
    return height;
}

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
        _likesTagList=[[DWTagList alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeIconView.frame), CGRectGetMinY(self.likeIconView.frame), [LZAlbum contentWidth]-CGRectGetWidth(self.likeIconView.frame), 0)];
        _likesTagList.textColor = LZLinkTextForegroundColor;
        _likesTagList.textShadowColor = [UIColor clearColor];
        _likesTagList.highlightedBackgroundColor = LZLinkTextHighlightColor;
        _likesTagList.tagDelegate = self;
        [_likesTagList setTagBackgroundColor:[UIColor clearColor]];
        [[self class] customLikesTagList:_likesTagList];
    }
    return _likesTagList;
}

+ (void)customLikesTagList:(DWTagList *)tagList {
    tagList.horizontalPadding=0;
    tagList.automaticResize = YES;
    tagList.bottomMargin = 0;
    tagList.font=[UIFont systemFontOfSize:kLZAlbumFontSize];
    tagList.labelMargin=0;
    tagList.verticalPadding = 0;
    tagList.cornerRadius = 0;
    tagList.borderWidth = 0;
}

-(UIView*)likeContainerView{
    if(_likeContainerView==nil){
        _likeContainerView=[[UIView alloc] initWithFrame:CGRectZero];
        _likeContainerView.autoresizesSubviews=YES;
        [_likeContainerView addSubview:self.likeIconView];
        [_likeContainerView addSubview:self.likesTagList];
        _likeContainerView.clipsToBounds = YES;
    }
    return _likeContainerView;
}

-(UIImageView*)likeIconView{
    if(_likeIconView==nil){
        _likeIconView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLZAlbumCommentIconHeight, kLZAlbumCommentIconHeight)];
        _likeIconView.image = [UIImage imageNamed:@"AlbumInformationLikeHL"];
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

#pragma mark -

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex{
    DLog();
}

- (void)setAlbum:(LZAlbum *)album {
    _album = album;
    [[self class] reloadLikesWithAlbum:album tagList:self.likesTagList];
    [self.commentTableView reloadData];
    [self setNeedsLayout];
}

+ (void)reloadLikesWithAlbum:(LZAlbum *)album tagList:(DWTagList *)tagList{
    NSMutableArray* likeTexts=[NSMutableArray array];
    for(int i=0;i<album.albumShareLikes.count;i++){
        if (i != 0) {
            [likeTexts addObject:@","];
        }
        [likeTexts addObject:album.albumShareLikes[i]];
    }
    [tagList setTags:likeTexts];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL shouldShowLike=self.album.albumShareLikes.count>0;
    BOOL shouldShowComment=self.album.albumShareComments.count>0;
    
    if(!shouldShowLike && !shouldShowComment){
        self.frame=CGRectZero;
        return;
    }
    
    CGFloat likesViewHeight = [[self class] caculateLikesViewHeightWithAlbum:self.album];
    CGRect likeContainerFrame=self.likeContainerView.frame;
    likeContainerFrame.size=CGSizeMake(CGRectGetWidth(self.bounds), likesViewHeight);
    self.likeContainerView.frame=likeContainerFrame;
    
    CGRect commentTableFrame=self.commentTableView.frame;
    commentTableFrame.origin.y=CGRectGetMaxY(self.likeContainerView.frame);
    commentTableFrame.size.height = [[self class] caculateCommentsViewHeightWithAlbum:self.album];
    self.commentTableView.frame=commentTableFrame;
    
//    CGRect frame=self.frame;
//    frame.size.height= CGRectGetMaxY(self.commentTableView.frame);
//    self.frame=frame;
}

#pragma mark - UITablView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.album.albumShareComments.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZAlbumCommentTableViewCell* commentCell=[tableView dequeueReusableCellWithIdentifier:kLZAlbumCommentCellIndetifier forIndexPath:indexPath];
    if(commentCell==nil){
        commentCell=[[LZAlbumCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLZAlbumCommentCellIndetifier];
    }
    LZAlbumComment* albumComment=self.album.albumShareComments[indexPath.row];
    [commentCell setupItem:albumComment atIndexPath:indexPath];
    return commentCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZAlbumComment* albumComment=self.album.albumShareComments[indexPath.row];
    CGFloat cellHeight=[LZAlbumCommentTableViewCell calculateCellHeightWithAlbumComment:albumComment fixWidth:[LZAlbum contentWidth]];
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.albumLikesCommentsViewDelegate respondsToSelector:@selector(didSelectCommentAtIndexPath:)]){
        [self.albumLikesCommentsViewDelegate didSelectCommentAtIndexPath:indexPath];
    }
}

@end
