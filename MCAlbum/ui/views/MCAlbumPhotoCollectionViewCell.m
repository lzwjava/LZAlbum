//
//  MCAlbumPhotoCollectionViewCell.m
//  ClassNet
//
//  Created by lzw on 15/3/27.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "MCAlbumPhotoCollectionViewCell.h"

@implementation MCAlbumPhotoCollectionViewCell

-(UIImageView*)photoImageView{
    if(_photoImageView==nil){
        _photoImageView=[[UIImageView alloc] initWithFrame:self.bounds];
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

@end
