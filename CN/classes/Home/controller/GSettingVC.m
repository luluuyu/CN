//
//  GSettingVC.m
//  CN
//
//  Created by AlfieL on 14-6-15.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GSettingVC.h"
#import "GNetDataCount.h"
#import "GStatusCacheTool.h"
#import "GRightsReserved.h"
@interface GSettingVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *NetDataContLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *StatusCountLabel;
- (IBAction)rightCellBeCicked;
@property (weak, nonatomic) IBOutlet UITableViewCell *RightsReservedCell;


@end

@implementation GSettingVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.NetDataContLabel.detailTextLabel.text = [NSString stringWithFormat:@"%lld MB",[GNetDataCount getInterfaceMBytes] / 1024 /1024];
    self.StatusCountLabel.detailTextLabel.text = [GStatusCacheTool getSidCount];
}



- (IBAction)rightCellBeCicked {
    self.RightsReservedCell.selected = YES;
    GRightsReserved *grv = [[GRightsReserved alloc]init];
    grv.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:grv animated:YES];
    self.RightsReservedCell.selected = NO;
    
}
@end
