//
//  LZAlbumComment.h
//  LZAlbum
//
//  Created by lzw on 15/8/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZAlbumComment : NSObject

@property (nonatomic,copy) NSString *fromUsername;
@property (nonatomic,copy) NSString *toUsername;
@property (nonatomic,copy) NSString *commentContent;

- (NSRange)fromUsernameRange;
- (NSRange)toUsernameRange;
- (NSString *)fullCommentText;

@end
