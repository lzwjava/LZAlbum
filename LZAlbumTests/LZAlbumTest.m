//
//  LZAlbumTests.m
//  LZAlbumTests
//
//  Created by lzw on 15/11/16.
//  Copyright © 2015年 lzw. All rights reserved.
//

#import "LZBaseTest.h"
#import "LZAlbumManager.h"
#import "LZAlbum.h"

@interface LZAlbumTest : LZBaseTest

@end

@implementation LZAlbumTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFindAlbums {
    [[LZAlbumManager manager] findAlbumWithBlock:^(NSArray *objects, NSError *error) {
        assertNil(error);
        assertTrue(objects.count > 0);
        NOTIFY
    }];
    WAIT
}

- (void)testCreateAlbum {
    NSError *error;
    [[LZAlbumManager manager] createAlbumWithText:@"hi" photos:@[] error:&error];
    assertNil(error);
}

- (void)testCreateAndFindAlbum {
    NSError *error;
    [[LZAlbumManager manager] createAlbumWithText:@"Hi!!!" photos:@[] error:&error];
    assertNil(error);
    [[LZAlbumManager manager] findAlbumWithBlock:^(NSArray *objects, NSError *error) {
        assertNil(error);
        assertTrue(objects.count > 0);
        LCAlbum *album = objects[0];
        assertEqualObjects(album.albumContent, @"Hi!!!");
        NOTIFY
    }];
    WAIT
}

@end
