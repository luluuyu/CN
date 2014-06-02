//
//  GTableViewCell.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-5-1.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GTableViewCell.h"
@interface GTableViewCell ()



@end

@implementation GTableViewCell

// 去除 cell 的选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    GTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GTableViewCell" owner:nil options:nil][0];
        
    }
    
    return cell;
}


@end
