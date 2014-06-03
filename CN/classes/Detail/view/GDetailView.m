//
//  GDetailView.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GTextFont [UIFont systemFontOfSize:16]
#define kMargin    30
#import "GDetailView.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"

@interface GDetailView ()



@end


@implementation GDetailView

// 重写 arr 的 set 方法, 设置 View
- (void)setArr:(NSArray *)arr
{
    _arr = arr;
    
    
    
    
    [self processArr:arr];
}

// 处理 arr
- (void)processArr:(NSArray *)arr
{
    for (NSDictionary *dict in arr) {
        
        NSString *contentString = [dict objectForKey:@"content"];
        NSString *imageURL      = [dict objectForKey:@"imageURL"];
    
        if (contentString.length > 1) {
            [self addLabelWithString:contentString];
        }else if (imageURL){
            [self addImageViewWithURL:imageURL];
        }
    }
}

/**
 *  计算文字的高度
 *
 *  @param string 要计算的文字
 *
 *  @return 字体的大小
 */
- (CGSize)caculateContentSize:(NSString *)string
{
    CGSize contSize;
    if (IOS7_OR_LATER) {
        CGSize textMaxSize = CGSizeMake(290, MAXFLOAT);
        contSize = [string size1WithFont:GTextFont maxSize:textMaxSize];
    }else{
        CGSize textMaxSize = CGSizeMake(290, MAXFLOAT);
        contSize = [string sizeWithFont:GTextFont constrainedToSize:textMaxSize lineBreakMode:0];
    }
    return contSize;
}



- (void)addLabelWithString:(NSString *)contentString
{
    // 先计算size
    CGSize contentSize = [self caculateContentSize:contentString];
    
    if ( self.contSize.size.width < 10) {
        // title 下面的第一个内容
        // 创建label
        UILabel *contLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, contentSize.width, contentSize.height)];
        contLabel.font = [contLabel.font fontWithSize:16];
//        contLabel.font = [UIFont fontWithName:@"Hiragino Mincho ProN" size:16];
        contLabel.text = [NSString stringWithFormat:@"    %@",contentString];
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.numberOfLines = 0;
        [self addSubview:contLabel];
        self.contSize = CGRectMake( 0 , 60 + contentSize.height + kMargin, 300, contentSize.width + contentSize.height + kMargin );
        
        
    }else {
        
        // 非第一个内容
        UILabel *contLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, self.contSize.origin.y, contentSize.width, contentSize.height)];
        contLabel.font = [contLabel.font fontWithSize:16];
        contLabel.text = [NSString stringWithFormat:@"    %@",contentString];
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.numberOfLines = 0;
        self.contSize = CGRectMake( 0 , self.contSize.origin.y + contentSize.height + kMargin, 300, self.contSize.origin.y + contentSize.height + kMargin);
        [self insertSubview:contLabel atIndex:self.subviews.count];

    }
    
}

- (void)addImageViewWithURL:(NSString *)string
{
    
    
    
    if ( self.contSize.size.width < 10) {
        self.contSize = CGRectMake( 0 , 60 + 200 + kMargin, 300, 200 + kMargin);
        // title 下面的第一个内容
        // 创建label
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(30, 60 , 260, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            NSLog(@"c") ;
        }];
        [self addSubview:imageView];
        
        
    }else {
        
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(30, self.contSize.origin.y , 260, 200)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            
        }];
        [self insertSubview:imageView atIndex:self.subviews.count];
        self.contSize = CGRectMake( 0 , self.contSize.size.height + 200 + kMargin, 300, self.contSize.size.height + 200 + kMargin);
    }
}




- (void)setTitleLabelWithTitle:(NSString *)title
{
    //    UILabel *titleLabel = [[UILabel alloc]init];
    //    if (IOS7_OR_LATER) {
    //        titleLabel.frame = CGRectMake(20,0 , 260, 60);
    //    }else{
    //        titleLabel.frame = CGRectMake(20,0 , 260, 60);
    //    }
    
    //    titleLabel.text = self.GDM.title_show;
    //    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    //    titleLabel.numberOfLines = 0;
}
- (void)setupView{
    
    //    UILabel *contLable  = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, self.contSize.width, self.contSize.height)];
    
    //    contLable.font = [contLable.font fontWithSize:16];
    //    contLable.text = detailContent;
    //    contLable.lineBreakMode = NSLineBreakByCharWrapping;
    //    contLable.numberOfLines = 0;
    //
    //    titleLabel.text = self.GDM.title_show;
    //    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    //    titleLabel.numberOfLines = 0;
    //
    //
    //    //self.navigationController.navigationBarHidden = YES;
    //
    //
    //
    //
    //
    //    CGSize mainSize =   [UIScreen mainScreen].bounds.size;
    //    // 相对父控件显示大小
    //
    //    UIScrollView *scrollView = [[UIScrollView alloc]init];
    //    if (IOS7_OR_LATER) {
    //        scrollView.frame = CGRectMake(0, 60,mainSize.width , mainSize.height-30);
    //    }else{
    //        scrollView.frame = CGRectMake(0, 0,mainSize.width , mainSize.height-30);
    //                                      }
    //    //scrollView 的显示范围
    //    scrollView.contentSize = CGSizeMake( contLable.frame.size.width, self.contSize.height + 90);
    //
    //
    //
    //
    //    [scrollView addSubview:titleLabel];
    //    [scrollView addSubview:contLable];
    //       
    //    [self.view addSubview:scrollView];
    //        
    
}


@end
