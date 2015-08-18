//
//  MCBaseTC.m
//  LZAlbum
//
//  Created by lzw on 15/3/12.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "LZBaseTC.h"

@interface LZBaseTC ()

@end

@implementation LZBaseTC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

-(UITableView*)tableView{
    if(_tableView==nil){
        CGRect tableViewFrame = self.view.bounds;
        tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.tabBarController.tabBar.bounds)));
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableViewStyle];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
}

-(NSMutableArray*)dataSource{
    if(_dataSource==nil){
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
