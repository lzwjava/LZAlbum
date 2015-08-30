//
//  MCAlbumPhotoCollectionViewCell.m
//  LZAlbum
//
//  Created by lzw on 15/3/27.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumPhotoCollectionViewCell.h"

@implementation LZAlbumPhotoCollectionViewCell

-(UIImageView*)photoImageView{
    if(_photoImageView==nil){
        _photoImageView=[[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode=UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds=YES;
    }
    return _photoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];    
    self.photoImageView.image = nil;
    self.indexPath = nil;
}

@end
