//
//  MCAlbumCollectionFlowLayout.m
//  LZAlbum
//
//  Created by lzw on 15/3/27.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumCollectionFlowLayout.h"
#import "LZAlbum.h"

@implementation LZAlbumCollectionFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize=CGSizeMake(kLZAlbumPhotoSize, kLZAlbumPhotoSize);
        self.minimumInteritemSpacing=kLZAlbumPhotoInset;
        self.minimumLineSpacing=kLZAlbumPhotoInset;
    }
    return self;
}

@end
