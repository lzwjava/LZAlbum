//
//  MCAlbumCreateVC.m
//  ClassNet
//
//  Created by lzw on 15/4/1.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "MCAlbumCreateVC.h"
#import "XHPhotographyHelper.h"
#import "MCAlbumManager.h"
#import "MCAlbumPhotoCollectionViewCell.h"

static CGFloat kMCAlbumCreateVCPhotoSize=60;

@interface MCAlbumCreateVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (nonatomic,strong) NSMutableArray* selectPhotos;

@property (strong,nonatomic) MCAlbumManager* feedManager;

@property (strong,nonatomic) XHPhotographyHelper* photographyHelper;

@end

static NSString* photoCellIndentifier=@"cell";

@implementation MCAlbumCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新建";
    UIBarButtonItem *logoutItem=[[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    UIBarButtonItem *createItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createFeed)];
    self.navigationItem.rightBarButtonItems=@[createItem,logoutItem];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    [self.photoCollectionView registerClass:[MCAlbumPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCellIndentifier];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logout{
    [AVUser logOut];
    exit(0);
}

-(void)createFeed{
    if(self.contentTextField.text.length!=0 || self.selectPhotos.count!=0){
        WEAKSELF
        [self showProgress];
        [self runInGlobalQueue:^{
            NSError* error;
            [weakSelf.feedManager createAlbumWithText:self.contentTextField.text photos:self.selectPhotos error:&error];
            [weakSelf runInMainQueue:^{
                [weakSelf hideProgress];
                if(error==nil){
                    [_albumVC refresh];
                    [weakSelf dismiss];
                }else{
                    [weakSelf alertError:error];
                }
            }];
        }];
    }else{
        [self alert:@"请完善内容"];
    }
}

#pragma mark - Propertys
-(XHPhotographyHelper*)photographyHelper{
    if(_photographyHelper==nil){
        _photographyHelper=[[XHPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

-(MCAlbumManager*)feedManager{
    if(_feedManager==nil){
        _feedManager=[[MCAlbumManager alloc] init];
    }
    return _feedManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray*)selectPhotos{
    if(_selectPhotos==nil){
        _selectPhotos=[NSMutableArray array];
    }
    return _selectPhotos;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.selectPhotos.count==9){
        return self.selectPhotos.count;
    }else{
        return self.selectPhotos.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MCAlbumPhotoCollectionViewCell* cell=(MCAlbumPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:photoCellIndentifier forIndexPath:indexPath];
    if(indexPath.row==self.selectPhotos.count){
        cell.photoImageView.image=[UIImage imageNamed:@"AlbumAddBtn"];
        cell.photoImageView.highlightedImage=[UIImage imageNamed:@"AlbumAddBtnHL"];
        return cell;
    }else{
        cell.photoImageView.image=self.selectPhotos[indexPath.row];
        cell.photoImageView.highlightedImage=nil;
        return cell;
    }
}

#pragma mark - Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMCAlbumCreateVCPhotoSize, kMCAlbumCreateVCPhotoSize);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)addImage:(UIImage*)image{
    [self.selectPhotos addObject:image];
    [self.photoCollectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_selectPhotos.count){
        [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            if (image) {
                [self addImage:image];
            } else {
                if (!editingInfo)
                    return ;
                image=[editingInfo valueForKey:UIImagePickerControllerOriginalImage];
                if(image){
                    [self addImage:image];
                }
            }
        }];
    }
}

@end
