//
//  GTableViewCell.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-5-1.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXLabel;
@interface GTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet FXLabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIView *cell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
