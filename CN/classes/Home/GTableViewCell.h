//
//  GTableViewCell.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-5-1.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
