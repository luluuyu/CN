//
//  GTableViewCell.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-5-1.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GTableViewCell.h"
@interface GTableViewCell ()
@property (nonatomic,copy)NSString *lastObj;

@end

@implementation GTableViewCell

- (void)awakeFromNib
{
    self.titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLable.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    GTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GTableViewCell" owner:nil options:nil][0];
        cell.backgroundColor = [UIColor redColor];
    }
    

    
    return cell;
}


@end
