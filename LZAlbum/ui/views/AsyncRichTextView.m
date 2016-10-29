//
//  AsyncRichTextView.m
//  LZAlbum
//
//  Created by liudonghuan on 16/10/27.
//  Copyright © 2016年 lzw. All rights reserved.
//

#import "AsyncRichTextView.h"
#import "LZAlbumRichTextView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LZAlbumCollectionFlowLayout.h"
#import "LZAlbumPhotoCollectionViewCell.h"
#import "XHImageViewer.h"
#import <NSDate+DateTools.h>


@interface AsyncRichTextView()<UICollectionViewDataSource,UICollectionViewDelegate,MCAlbumLikesCommentsViewDelegate, XHImageViewerDelegate>
{
    
}
@property (nonatomic,strong) UIImageView* avatarImageView;
@property (nonatomic,strong) UICollectionView* shareCollectionView;
@property (nonatomic,strong) UIButton* commentButton;
@property (nonatomic,strong) LZAlbumLikesCommentsView* likesCommentsView;
@end
static NSString* photoCollectionViewIdentifier=@"photoCell";
@implementation AsyncRichTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame Album:(LZAlbum *)album;
{
    if (self = [super initWithFrame:frame]) {
        _album = album;
        NSString *text = album.albumShareContent;
        [self drawViews];
        [self setupImage];
    }
    return self;
}

-(LZAlbumLikesCommentsView*)likesCommentsView{
    if(_likesCommentsView==nil){
        _likesCommentsView=[[LZAlbumLikesCommentsView alloc] initWithFrame:CGRectZero];
        _likesCommentsView.albumLikesCommentsViewDelegate=self;
    }
    _likesCommentsView.frame = CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing,kLZAlbumAvatarSpacing+kLZAlbumUsernameHeight + _album.contentHeight + _album.collectionHeight + 2*kLZAlbumContentLineSpacing*4, [LZAlbum contentWidth], self.album.commentsHeight);
    _likesCommentsView.album = self.album;
    return _likesCommentsView;
}
-(UIButton*)commentButton{
    if(_commentButton==nil){
        _commentButton=[[UIButton alloc] initWithFrame:CGRectZero];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMoreHL"] forState:UIControlStateHighlighted];
        [_commentButton addTarget:self action:@selector(didCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _commentButton.frame = CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing + [LZAlbum contentWidth]-kLZAlbumCommentButtonWidth, CGRectGetMaxY(_shareCollectionView.frame)+kLZAlbumContentLineSpacing, kLZAlbumCommentButtonWidth, kLZAlbumCommentButtonHeight);
    return _commentButton;
}

-(UICollectionView*)shareCollectionView{
    if(_shareCollectionView==nil){
        _shareCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[LZAlbumCollectionFlowLayout alloc] init]];
        _shareCollectionView.backgroundColor=[UIColor clearColor];
        [_shareCollectionView registerClass:[LZAlbumPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCollectionViewIdentifier];
        _shareCollectionView.delegate=self;
        _shareCollectionView.dataSource=self;
    }
    _shareCollectionView.frame=CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing,kLZAlbumAvatarSpacing + kLZAlbumUsernameHeight + _album.contentHeight + kLZAlbumContentLineSpacing, kLZAlbumPhotoSize*3+2*kLZAlbumPhotoInset, _album.collectionHeight);
    return _shareCollectionView;
}

-(UIImageView*)avatarImageView{
    if(_avatarImageView==nil){
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kLZAlbumAvatarSpacing,kLZAlbumAvatarSpacing, kLZAlbumAvatarImageSize, kLZAlbumAvatarImageSize)];
    }
    return _avatarImageView;
}

- (void)setupImage
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_album.avatarUrl]];
}

- (void)drawViews
{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.shareCollectionView];
    [self addSubview:self.commentButton];
    [self addSubview:self.likesCommentsView];
}

- (BOOL)drawInRect:(CGRect)rect Context:(CGContextRef)context
{
    if (_album == nil) {
        return YES;
    }
    if (_album.username == nil) {
        _album.username = @"no name";
    }
//    sleep(2);
    //名字一般只有一行
    NSMutableAttributedString *nameAttributed = [[NSMutableAttributedString alloc]initWithString:_album.username];
    [nameAttributed addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kLZAlbumFontSize],NSForegroundColorAttributeName:RGB(52, 164, 254)} range:NSMakeRange(0, nameAttributed.string.length)];
    [nameAttributed drawInRect:CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing,kLZAlbumAvatarSpacing,[LZAlbum contentWidth] , kLZAlbumUsernameHeight)];

    //时间只有一行
    NSMutableAttributedString *timeAttributed = [[NSMutableAttributedString alloc]initWithString:_album.albumShareTimestamp.timeAgoSinceNow];
    [timeAttributed addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGB(180, 196, 210)} range:NSMakeRange(0, timeAttributed.string.length)];
    [timeAttributed drawInRect:CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing,kLZAlbumAvatarSpacing+kLZAlbumUsernameHeight + _album.contentHeight + _album.collectionHeight + 2*kLZAlbumContentLineSpacing,[LZAlbum contentWidth] , kLZAlbumUsernameHeight)];
    
    NSMutableAttributedString *nameAttributed2 = [[NSMutableAttributedString alloc]initWithString:_album.albumShareContent];
    [nameAttributed2 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kLZAlbumFontSize],NSForegroundColorAttributeName:RGB(52, 164, 254)} range:NSMakeRange(0, _album.albumShareContent.length)];
//    [nameAttributed2 drawInRect:CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing, kLZAlbumAvatarSpacing + kLZAlbumUsernameHeight , [LZAlbum contentWidth], _album.contentHeight)];
    //矩阵变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -rect.size.height);

    
    //正文，图文混排，短链等。需要图文混排，部分文字需要可点击等功能，因此用coretext
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_album.albumShareContent];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kLZAlbumFontSize],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, _album.albumShareContent.length)];
    
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds =  CGRectMake(kLZAlbumAvatarSpacing+kLZAlbumAvatarImageSize+kLZAlbumAvatarSpacing, kLZAlbumAvatarSpacing + kLZAlbumUsernameHeight + kLZAlbumContentLineSpacing , [LZAlbum contentWidth], rect.size.height);
    
    CGPathAddRect(path, NULL, [self changeRect:bounds ParentRect:rect]);
    
    CTFrameRef kFrameRef = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(kFrameRef, context);
    
    CFRelease(path);
    CFRelease(ctFramesetter);
    return YES;
}

- (CGRect)changeRect:(CGRect)rect ParentRect:(CGRect)pRect;
{
    CGRect newRect = rect;
    newRect.origin.y = pRect.size.height - rect.size.height - rect.origin.y;
    return newRect;
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
//    self.selectedIndexPath = indexPath;
    
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
//    [self.imageLoadingIndicator startAnimating];
    [selectedView sd_setImageWithURL:[NSURL URLWithString:photo.originUrl] placeholderImage:selectedView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.imageLoadingIndicator stopAnimating];
    }];
}

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
//    [self.imageLoadingIndicator stopAnimating];
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
