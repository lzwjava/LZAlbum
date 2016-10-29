//
//  MCClassAlbumVC.h
//  LZAlbum
//
//  Created by lzw on 15/3/24.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZBaseTC.h"
#import "FPSObject.h"
@interface LZAlbumVC : LZBaseTC
@property (nonatomic,strong)FPSObject *fps;
-(void)refresh;

@end
