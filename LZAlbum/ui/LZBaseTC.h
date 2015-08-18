//
//  MCBaseTC.h
//  LZAlbum
//
//  Created by lzw on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZBaseVC.h"

@interface LZBaseTC : LZBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,assign) UITableViewStyle tableViewStyle;

@property (nonatomic,strong) NSMutableArray* dataSource;

@end
