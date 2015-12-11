//
//  LZAlbumTests.m
//  LZAlbumTests
//
//  Created by lzw on 15/11/16.
//  Copyright © 2015年 lzw. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LZAlbumManager.h"

@interface LZAlbumTests : XCTestCase

@end

@implementation LZAlbumTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFindAlbums {
    [[LZAlbumManager manager] findAlbumWithBlock:^(NSArray *objects, NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(objects.count > 0);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
    }];
    [self expectationForNotification:@"test" object:nil handler:nil];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end
