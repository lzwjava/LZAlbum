//
//  MCAlbumCollectionFlowLayout.m
//  ClassNet
//
//  Created by lzw on 15/3/27.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "MCAlbumCollectionFlowLayout.h"
#import "MCAlbum.h"

@implementation MCAlbumCollectionFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize=CGSizeMake(kMCAlbumPhotoSize, kMCAlbumPhotoSize);
        self.minimumInteritemSpacing=kMCAlbumPhotoInset;
        self.minimumLineSpacing=kMCAlbumPhotoInset;
    }
    return self;
}

@end
