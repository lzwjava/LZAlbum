//
//  LZAlbumTests.m
//  LZAlbumTests
//
//  Created by lzw on 15/11/16.
//  Copyright © 2015年 lzw. All rights reserved.
//

#import "LZBaseTest.h"
#import "LZAlbumManager.h"

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

@end
