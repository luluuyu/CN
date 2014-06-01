//
//  MJViewController.h
//  04-图片轮播器
//
//  Created by apple on 14-3-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSView : UIScrollView

@property (weak, nonatomic)  GSView *scrollView;

- (GSView *)setImage:(GSView *)sv;
@end
