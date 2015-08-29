//
//  MCAlbum.m
//  LZAlbum
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbum.h"

@implementation LZPhoto

+ (instancetype)photoWithOriginUrl:(NSString *)originUrl thumbnailUrl:(NSString *)thumbnailUrl {
    LZPhoto *photo = [[LZPhoto alloc] init];
    photo.originUrl = originUrl;
    photo.thumbnailUrl = thumbnailUrl;
    return photo;
}

- (NSString *)actualThumbnailUrl {
    if (self.thumbnailUrl) {
        return self.thumbnailUrl;
    } else {
        return self.originUrl;
    }
}

@end

@implementation LZAlbum

@end
