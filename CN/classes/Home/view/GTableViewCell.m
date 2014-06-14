//
//  GTableViewCell.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-5-1.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GTableViewCell.h"
#import "FXLabel.h"
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
        // 设置 cell 文字的阴影
        cell.titleLable.shadowOffset = CGSizeMake(0.0f, 1.0f);
        cell.titleLable.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.35f];
        cell.titleLable.shadowBlur = 3.0f;
    }
    
    return cell;
}


@end
