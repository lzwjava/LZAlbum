//
//  LZAlbumComment.m
//  LZAlbum
//
//  Created by lzw on 15/8/29.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZAlbumComment.h"

@interface LZAlbumComment()

@property (nonatomic, assign) NSRange fromRange;
@property (nonatomic, assign) NSRange toRange;
@property (nonatomic, strong) NSString *fullText;

@end

@implementation LZAlbumComment

- (NSRange)fromUsernameRange {
    [self buildCommentText];
    return self.fromRange;
}

- (NSRange)toUsernameRange {
    [self buildCommentText];
    return self.toRange;
}

- (NSString *)fullCommentText {
    [self buildCommentText];
    return self.fullText;
}

- (void)buildCommentText {
    NSMutableString *text = [NSMutableString string];
    
    NSRange fromRange = NSMakeRange(NSNotFound, 0);
    if (self.fromUsername) {
        [text appendString:self.fromUsername];
        fromRange.location = 0;
        fromRange.length = self.fromUsername.length;
    }
    
    NSRange toRange = NSMakeRange(NSNotFound, 0);
    if (self.toUsername) {
        [text appendString:@"回复"];
        toRange.location = text.length;
        toRange.length = self.toUsername.length;
        [text appendString:self.toUsername];
    }
    if (self.commentContent) {
        [text appendString:@":"];
        [text appendString:self.commentContent];
    }
    
    self.fromRange = fromRange;
    self.toRange= toRange;
    self.fullText = text;
}

@end
