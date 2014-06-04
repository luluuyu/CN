//
//  NSString+Extension.m
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#define GLabelTextSize          [UIFont systemFontOfSize:16]
#define GLabelFontSize           16
#define GLabelMaxWidth           300        // label 最大的宽度
#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};

        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
  
}

- (CGSize)sizeOfString:(NSString *)string
{
    CGSize contSize;
    if (IOS7_OR_LATER) {
        CGSize textMaxSize = CGSizeMake(GLabelMaxWidth, MAXFLOAT);
        contSize = [string sizeWithFont:GLabelTextSize maxSize:textMaxSize];
    }else{
        CGSize textMaxSize = CGSizeMake(GLabelMaxWidth, MAXFLOAT);
        contSize = [string sizeWithFont:GLabelTextSize constrainedToSize:textMaxSize lineBreakMode:0];
    }
    return contSize;
}

@end