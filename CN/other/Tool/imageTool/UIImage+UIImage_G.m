//
//  UIImage+UIImage_G.m
//  新浪微博
//
//  Created by AlfieL on 14-5-5.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "UIImage+UIImage_G.h"

@implementation UIImage (G)

+ (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
       NSString  *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) {
            image = [UIImage imageNamed:name];
        }return image;
    }return [UIImage imageNamed:name];
}

+ (UIImage *)resizeImageWithImageName:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    return  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5  topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)resizeImageWithImageName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
