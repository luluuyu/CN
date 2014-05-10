//
//  UIImage+UIImage_G.h
//  新浪微博
//
//  Created by AlfieL on 14-5-5.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_G)
/**
 *  加载图片
 *
 *  name: 图片名
 */

+ (UIImage *)imageWithName:(NSString *)name;


+ (UIImage *)resizeImageWithImageName:(NSString *)name;

+ (UIImage *)resizeImageWithImageName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
