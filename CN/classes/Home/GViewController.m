//
//  GViewController.m
//  CN
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GViewController.h"
#import "GTableViewCell.h"

@interface GViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTableViewCell *cell = [GTableViewCell cellWithTableView:tableView];
    return cell;
}


@end
