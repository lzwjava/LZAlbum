//
//  MCAlbumRichTextView.m
//  LZAlbum
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumRichTextView.h"
#import "LZAlbumCollectionFlowLayout.h"
#import "LZAlbumPhotoCollectionViewCell.h"
#import "LZAlbumLikesCommentsView.h"
#import "LZAlbumCommentTableViewCell.h"
#import "LZMacros.h"
#import "XHImageViewer.h"
#import <NSDate+DateTools.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LZAlbumRichTextView()<UICollectionViewDataSource,UICollectionViewDelegate,MCAlbumLikesCommentsViewDelegate, XHImageViewerDelegate>

@property (nonatomic,strong) UIImageView* avatarImageView;

@property (nonatomic,strong) UILabel* usernameLabel;

@property (nonatomic,strong) UILabel* contentLabel;

@property (nonatomic,strong) UICollectionView* shareCollectionView;

@property (nonatomic,strong) UILabel* timestampLabel;

@property (nonatomic,strong) UIButton* commentButton;

@property (nonatomic,strong) LZAlbumLikesCommentsView* likesCommentsView;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) UIActivityIndicatorView *imageLoadingIndicator;

@end

static NSString* photoCollectionViewIdentifier=@"photoCell";

@implementation LZAlbumRichTextView

+(NSFont*)contentFont{
    return  [UIFont systemFontOfSize:kLZAlbumFontSize];
}

+(CGFloat)getLabelHeightWithText:(NSString*)text maxWidth:(CGFloat)maxWidth font:(NSFont*)font{
    return [text boundingRectWithSize:CGSizeMake(maxWidth,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

+(CGFloat)getContentLabelHeightWithAlbum:(LZAlbum *)album{
    NSString *text = album.albumShareContent;
    if(text.length == 0){
        return 0;
    }
    return [self getLabelHeightWithText:text maxWidth:[LZAlbum contentWidth] font:[self contentFont]];
}

+(CGFloat)getPhotoCollectionViewHeightWithAlbum:(LZAlbum *)album{
    NSInteger photoCount = album.albumSharePhotos.count;
    if(photoCount==0){
        return 0;
    }
    NSInteger row=photoCount/3+(photoCount%3 ? 1:0);
    return row*kLZAlbumPhotoSize+(row-1)*kLZAlbumPhotoInset;
}

+(CGFloat)calculateRichTextHeightWithAlbum:(LZAlbum*)album {
	if(album==nil) {
		return 0;
	}
	CGFloat richTextHeight=kLZAlbumAvatarSpacing;
	richTextHeight += kLZAlbumUsernameHeight;
	if ([self shouldShowContentLabelWithAlbum:album]) {
		richTextHeight += kLZAlbumContentLineSpacing;
		richTextHeight += [[self class] getContentLabelHeightWithAlbum:album];
	}
	if ([self shouldShowPhotoCollectionViewWithAlbum:album]) {
		richTextHeight += kLZAlbumContentLineSpacing;
		richTextHeight += [[self class] getPhotoCollectionViewHeightWithAlbum:album];
	}
	richTextHeight+=kLZAlbumContentLineSpacing;
	richTextHeight+=kLZAlbumCommentButtonHeight;
	if([LZAlbumLikesCommentsView shouldShowLikesCommentsViewWithAlbum:album]) {
		richTextHeight += kLZAlbumContentLineSpacing;
		richTextHeight += [LZAlbumLikesCommentsView caculateLikesCommentsViewHeightWithAlbum:album];
	}
	richTextHeight+=kLZAlbumAvatarSpacing;
	return richTextHeight;
}

#pragma mark - should show

+ (BOOL)shouldShowContentLabelWithAlbum:(LZAlbum *)album {
    return album.albumShareContent.length > 0;
}

+ (BOOL)shouldShowPhotoCollectionViewWithAlbum:(LZAlbum *)album {
    return album.albumSharePhotos.count > 0;
}

#pragma mark - View init

-(UIImageView*)avatarImageView{
    if(_avatarImageView==nil){
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kLZAlbumAvatarSpacing,kLZAlbumAvatarSpacing, kLZAlbumAvatarImageSize, kLZAlbumAvatarImageSize)];
    }
    return _avatarImageView;
}

-(UILabel*)usernameLabel{
    if(_usernameLabel==nil){
        _usernameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+kLZAlbumAvatarSpacing, kLZAlbumAvatarSpacing,[LZAlbum contentWidth] , kLZAlbumUsernameHeight)];
        _usernameLabel.backgroundColor=[UIColor clearColor];
        _usernameLabel.textColor=RGB(52, 164, 254);
    }
    return _usernameLabel;
}

-(UILabel*)contentLabel{
    if(!_contentLabel){
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font=[UIFont systemFontOfSize:kLZAlbumFontSize];
        _contentLabel.backgroundColor=[UIColor clearColor];
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}

-(UICollectionView*)shareCollectionView{
    if(_shareCollectionView==nil){
        _shareCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[LZAlbumCollectionFlowLayout alloc] init]];
        _shareCollectionView.backgroundColor=[UIColor clearColor];
        [_shareCollectionView registerClass:[LZAlbumPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCollectionViewIdentifier];
        _shareCollectionView.delegate=self;
        _shareCollectionView.dataSource=self;
    }
    return _shareCollectionView;
}

-(UILabel*)timestampLabel{
    if(_timestampLabel==nil){
        _timestampLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _timestampLabel.font=[UIFont systemFontOfSize:12];
        _timestampLabel.textColor=RGB(180, 196, 210);
    }
    return _timestampLabel;
}

-(UIButton*)commentButton{
    if(_commentButton==nil){
        _commentButton=[[UIButton alloc] initWithFrame:CGRectZero];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMoreHL"] forState:UIControlStateHighlighted];
        [_commentButton addTarget:self action:@selector(didCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

-(LZAlbumLikesCommentsView*)likesCommentsView{
    if(_likesCommentsView==nil){
        _likesCommentsView=[[LZAlbumLikesCommentsView alloc] initWithFrame:CGRectZero];
        _likesCommentsView.albumLikesCommentsViewDelegate=self;
    }
    return _likesCommentsView;
}

- (UIActivityIndicatorView *)imageLoadingIndicator {
    if (_imageLoadingIndicator == nil) {
        _imageLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _imageLoadingIndicator.center = self.window.center;
        _imageLoadingIndicator.hidesWhenStopped = YES;
        _imageLoadingIndicator.hidden = NO;
        [self.window addSubview:_imageLoadingIndicator];
    }
    [self.window bringSubviewToFront:_imageLoadingIndicator];
    return _imageLoadingIndicator;
}

-(void)setAlbum:(LZAlbum *)album{
    _album=album;
    self.usernameLabel.text=_album.username;
    self.contentLabel.text=album.albumShareContent;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:album.avatarUrl]];
    [self.shareCollectionView reloadData];
    self.timestampLabel.text=_album.albumShareTimestamp.timeAgoSinceNow;
    
    self.likesCommentsView.album = album;
    
    [self setNeedsLayout];
}

-(void)setup{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.shareCollectionView];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.commentButton];
    [self addSubview:self.likesCommentsView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat contentLabelY = CGRectGetMaxY(_usernameLabel.frame);
    if ([[self class] shouldShowContentLabelWithAlbum:self.album]) {
        contentLabelY += kLZAlbumContentLineSpacing;
    }
    CGRect contentFrame = CGRectMake(CGRectGetMinX(_usernameLabel.frame), contentLabelY, CGRectGetWidth(_usernameLabel.frame), [[self class] getContentLabelHeightWithAlbum:_album]);
    _contentLabel.frame=contentFrame;
    
    CGFloat shareCollectionViewY = CGRectGetMaxY(_contentLabel.frame);
    if ([[self class] shouldShowPhotoCollectionViewWithAlbum:self.album]) {
        shareCollectionViewY += kLZAlbumContentLineSpacing;
    }
    _shareCollectionView.frame=CGRectMake(CGRectGetMinX(_usernameLabel.frame),shareCollectionViewY, kLZAlbumPhotoSize*3+2*kLZAlbumPhotoInset, [[self class] getPhotoCollectionViewHeightWithAlbum:self.album]);
    
    _commentButton.frame=CGRectMake(CGRectGetMaxX(_contentLabel.frame)-kLZAlbumCommentButtonWidth, CGRectGetMaxY(_shareCollectionView.frame)+kLZAlbumContentLineSpacing, kLZAlbumCommentButtonWidth, kLZAlbumCommentButtonHeight);
    
    _timestampLabel.frame=CGRectMake(CGRectGetMinX(_contentLabel.frame), CGRectGetMinY(_commentButton.frame), CGRectGetWidth(_contentLabel.frame)-kLZAlbumCommentButtonWidth, CGRectGetHeight(_commentButton.frame));
    
    CGFloat likesCommentsViewY = CGRectGetMaxY(_timestampLabel.frame);
    if ([LZAlbumLikesCommentsView shouldShowLikesCommentsViewWithAlbum:self.album]) {
        likesCommentsViewY += kLZAlbumContentLineSpacing;
    }
    _likesCommentsView.frame=CGRectMake(CGRectGetMinX(_timestampLabel.frame), likesCommentsViewY , CGRectGetWidth(_contentLabel.frame), [LZAlbumLikesCommentsView caculateLikesCommentsViewHeightWithAlbum:_album]);
    
    CGRect frame=self.frame;
    frame.size.height = CGRectGetMaxY(_likesCommentsView.frame) + kLZAlbumAvatarSpacing;
    self.frame=frame;
}

#pragma mark - collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _album.albumSharePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LZAlbumPhotoCollectionViewCell* photoCell=[collectionView dequeueReusableCellWithReuseIdentifier:photoCollectionViewIdentifier forIndexPath:indexPath];
    if(photoCell==nil){
        photoCell=[[LZAlbumPhotoCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, kLZAlbumPhotoSize, kLZAlbumPhotoSize)];
    }
    LZPhoto *photo = self.album.albumSharePhotos[indexPath.row];
    [photoCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo.actualThumbnailUrl]];
    photoCell.indexPath=indexPath;
    return photoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    
    LZAlbumPhotoCollectionViewCell* photoCell=(LZAlbumPhotoCollectionViewCell*)[self.shareCollectionView cellForItemAtIndexPath:indexPath];
    
    NSArray* visibleCells=self.shareCollectionView.visibleCells;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"indexPath" ascending:YES];
    visibleCells = [visibleCells sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSMutableArray* imageViews=[NSMutableArray array];
    [visibleCells enumerateObjectsUsingBlock:^(LZAlbumPhotoCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
        [imageViews addObject:cell.photoImageView];
    }];
    XHImageViewer* imageViewer=[[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:imageViews selectedView:photoCell.photoImageView];
}

#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer didShowImageView:(UIImageView *)selectedView atIndex:(NSInteger)index {
    LZPhoto *photo = self.album.albumSharePhotos[index];
    [self.imageLoadingIndicator startAnimating];
    [selectedView sd_setImageWithURL:[NSURL URLWithString:photo.originUrl] placeholderImage:selectedView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imageLoadingIndicator stopAnimating];
    }];
}

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    [self.imageLoadingIndicator stopAnimating];
}

#pragma mark - action 

-(void)didCommentButtonClick:(UIButton*)sender{
    if([_richTextViewDelegate respondsToSelector:@selector(didCommentButtonClick:)]){
        [_richTextViewDelegate didCommentButtonClick:sender];
    }
}

-(void)didSelectCommentAtIndexPath:(NSIndexPath *)indexPath{
    if([_richTextViewDelegate respondsToSelector:@selector(didSelectCommentAtIndexPath:)]){
        [_richTextViewDelegate didSelectCommentAtIndexPath:indexPath];
    }
}

@end
