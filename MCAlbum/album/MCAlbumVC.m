//
//  MCAlbumVC.m
//
//  Created by lzw on 15/3/24.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "MCAlbumVC.h"
#import "XHPathCover.h"
#import "MCAlbumTableViewCell.h"
#import "MCAlbumOperationView.h"
#import "MCAlbumReplyView.h"
#import "MCAlbumCreateVC.h"
#import <NSDate+DateTools.h>
#import "MCAlbumManager.h"
#import "AVUser+MCCustomUser.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface MCAlbumVC ()<MCAlbumTableViewCellDelegate,MCAlbumOperationViewDelegate,MCAlbumReplyViewDelegate>

@property (nonatomic,strong) XHPathCover *albumHeaderPathCover;

@property (nonatomic,strong) MCAlbumOperationView *albumOperationView;

@property (nonatomic,strong) MCAlbumReplyView *albumReplyView;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) MCAlbumManager *albumManager;

@property (nonatomic,strong) NSMutableArray *lcAlbums;

@property (nonatomic,strong) NSIndexPath *commentSelectedIndexPath;

@end

@implementation MCAlbumVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.albumReplyView];
    
    self.title=@"朋友圈";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStylePlain target:self action:@selector(onAddAlbumButtonClicked)];
    self.tableView.tableHeaderView=self.albumHeaderPathCover;
    [self refresh];
}

-(void)refresh{
    DLog(@"refresh");
    [self showNetworkIndicator];
    WEAKSELF
    [self.albumManager findAlbumWithBlock:^(NSArray *lcAlbums, NSError *error) {
        [weakSelf hideNetworkIndicator];
        [weakSelf.albumHeaderPathCover stopRefresh];
        if([weakSelf filterError:error]){
            DLog(@"found");
            _lcAlbums=[lcAlbums mutableCopy];
            NSMutableArray* albums=[NSMutableArray array];
            for(LCAlbum* lcAlbum in lcAlbums){
                [albums addObject:[self showAlbumFromLCAlbum:lcAlbum]];
            }
            weakSelf.dataSource=albums;
            [weakSelf.tableView reloadData];
        }
    }];
}

-(MCAlbum*)showAlbumFromLCAlbum:(LCAlbum*)lcAlbum{
    MCAlbum* album=[[MCAlbum alloc] init];
    album.username=lcAlbum.creator.username;
    AVFile* avatarFile=[lcAlbum.creator objectForKey:KEY_AVATAR];
    album.avatarUrl=avatarFile.url;
    album.albumShareContent=lcAlbum.albumContent;
    NSMutableArray* photoUrls=[NSMutableArray array];
    for(AVFile* photoFile in lcAlbum.albumPhotos){
        [photoUrls addObject:photoFile.url];
    }
    album.albumSharePhotos=photoUrls;
    NSMutableArray* digNames=[NSMutableArray array];
    for(AVUser* digUser in lcAlbum.digUsers){
        [digNames addObject:digUser.username];
    }
    album.albumShareLikes=digNames;
    NSMutableArray* albumComments=[NSMutableArray array];
    for(MCComment* comment in lcAlbum.comments){
        MCAlbumComment* albumComment=[[MCAlbumComment alloc] init];
//        albumComment.commentUsername=comment.commentUser.username;
        albumComment.commentUsername=comment.commentUsername;
        albumComment.commentContent=comment.commentContent;
        [albumComments addObject:albumComment];
    }
    album.albumShareComments=albumComments;
    album.albumShareTimestamp=lcAlbum.createdAt;
    return album;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - views

-(XHPathCover*)albumHeaderPathCover{
    if(_albumHeaderPathCover==nil){
        _albumHeaderPathCover=[[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
        [_albumHeaderPathCover setBackgroundImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage"]];
        AVUser* user=[AVUser currentUser];
        AVFile* avatar=[user objectForKey:KEY_AVATAR];
        [_albumHeaderPathCover.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatar.url] forState:UIControlStateNormal];
        [_albumHeaderPathCover setInfo:@{XHUserNameKey:user.username}];
        _albumHeaderPathCover.isZoomingEffect=YES;
        WEAKSELF
        [_albumHeaderPathCover setHandleRefreshEvent:^{
            [weakSelf refresh];
        }];
        
        [_albumHeaderPathCover setHandleTapBackgroundImageEvent:^{
            DLog(@"tab background");
        }];
    }
    return _albumHeaderPathCover;
}

-(MCAlbumOperationView*)albumOperationView{
    if(_albumOperationView==nil){
        _albumOperationView=[MCAlbumOperationView initialOperationView];
        _albumOperationView.albumOperationViewDelegate=self;
    }
    return _albumOperationView;
}

-(MCAlbumReplyView*)albumReplyView{
    if(_albumReplyView==nil){
        _albumReplyView=[[MCAlbumReplyView alloc] initWithFrame:CGRectZero];
        _albumReplyView.albumReplyViewDelegate=self;
    }
    return _albumReplyView;
}

-(void)reloadLCAlbum:(LCAlbum*)lcAlbum AtIndexPath:(NSIndexPath*)indexPath{
    [self.lcAlbums replaceObjectAtIndex:indexPath.row withObject:lcAlbum];
    MCAlbum* album=[self showAlbumFromLCAlbum:lcAlbum];
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:album];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)addLike{
    LCAlbum* lcAlbum=self.lcAlbums[self.selectedIndexPath.row];
    [self.albumManager digOrCancelDigOfAlbum:lcAlbum block:^(BOOL succeeded, NSError *error) {
        if([self filterError:error]){
            [self reloadLCAlbum:lcAlbum AtIndexPath:self.selectedIndexPath];
        }
    }];
}

-(void)albumOperationView:(MCAlbumOperationView *)albumOperationView didClickOfType:(MCAlbumOperationType)operationType{
    if(operationType==MCAlbumOperationTypeLike){
        [self addLike];
    }else{
        [self.albumReplyView show];
    }
    [albumOperationView dismiss];
}

-(void)albumReplyView:(MCAlbumReplyView *)albumReplyView didReply:(NSString *)text{
    LCAlbum* lcAlbum=self.lcAlbums[self.selectedIndexPath.row];
    AVUser* toUser;
    if(_commentSelectedIndexPath==nil){
        toUser=lcAlbum.creator;
    }else{
        MCComment* comment=lcAlbum.comments[_commentSelectedIndexPath.row];
        toUser=comment.commentUser;
    }
    
    [self showProgress];
    [self.albumManager commentToUser:toUser AtAlbum:lcAlbum content:text block:^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if([self filterError:error]){
            [self reloadLCAlbum:lcAlbum AtIndexPath:self.selectedIndexPath];
            [self.albumReplyView finishReply];
        }
    }];
}

#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_albumHeaderPathCover scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_albumHeaderPathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_albumOperationView dismiss];
    
    [self.albumReplyView dismiss];
    
    [_albumHeaderPathCover scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_albumHeaderPathCover scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - action
-(void)onAddAlbumButtonClicked{
    MCAlbumCreateVC* albumCreateVC=[[MCAlbumCreateVC alloc] init];
    albumCreateVC.albumVC=self;
    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:albumCreateVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - tableview delegate

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifer=@"albumTableViewCellIdentifier";
    MCAlbumTableViewCell* albumTableViewCell= [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(albumTableViewCell==nil){
        albumTableViewCell=[[MCAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    albumTableViewCell.albumTableViewCellDelegate=self;
    albumTableViewCell.indexPath=indexPath;
    albumTableViewCell.currentAlbum=self.dataSource[indexPath.row];
    return albumTableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MCAlbumTableViewCell calculateCellHeightWithAlbum:self.dataSource[indexPath.row]];
}

#pragma mark - Cell Delegate

-(void)didCommentButtonClick:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    if(self.albumOperationView.shouldShowed==YES){
        [self.albumOperationView dismiss];
        return;
    }
    CGRect rectInTablew=[self.tableView rectForRowAtIndexPath:indexPath];
    CGFloat originY=rectInTablew.origin.y+button.frame.origin.y;
    CGRect targeRect=CGRectMake(button.frame.origin.x, originY, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
    _commentSelectedIndexPath=nil;
    _selectedIndexPath=indexPath;
    [self.albumOperationView showAtView:self.tableView rect:targeRect];
}

-(void)didSelectCommentAtCellIndexPath:(NSIndexPath *)cellIndexPath commentIndexPath:(NSIndexPath *)commentIndexPath{
    _commentSelectedIndexPath=commentIndexPath;
    _selectedIndexPath=cellIndexPath;
    [self.albumReplyView show];
}

#pragma mark - Data Propertys

-(MCAlbumManager*)albumManager{
    if(_albumManager==nil){
        _albumManager=[[MCAlbumManager alloc] init];
    }
    return _albumManager;
}

@end
