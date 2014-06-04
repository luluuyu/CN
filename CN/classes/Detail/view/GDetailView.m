//
//  GDetailView.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GLabelTextSize          [UIFont systemFontOfSize:16]
#define GLabelFontSize           16
#define GLabelMaxWidth           300        // label 最大的宽度
#define GImageMaxWidth           260        // imageView 最大的宽度
#define GImageMaxHight           200        // imageView 最大的 高度
#define GTitle_showHight         60
#define kLabelWithLabelMargin    30         // label 与 label 之间的间距
#define miniLabelTextLimited     5          // label 显示的最小文字限制
#define GLabelLeftSection        20         // label 的左边距
#define GLabelTopsection         60         // 首个 subView 上部预留边距



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
    
    // 处理 arr (设置 view 的显示)
    [self processArr:arr];
    
}

// 处理 arr (设置 view 的显示)
- (void)processArr:(NSArray *)arr
{
    [self setTitleAndSubtitle];
    
    for (NSDictionary *dict in arr) {
        
        NSString *contentString = [dict objectForKey:@"content"];
        NSString *imageURL      = [dict objectForKey:@"imageURL"];
        
        if (contentString.length > miniLabelTextLimited) {
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



- (void)addLabelWithString:(NSString *)contentString
{
    // 先计算size
    CGSize contentSize = [self sizeOfString:contentString];
//    
//    if ( !self.contSize.size.width ) {
//        
//        // title 下面的第一个内容
//        // 创建label & 设置 label 的显示
//        UILabel *contLabel  = [[UILabel alloc]initWithFrame:
//                               CGRectMake(GLabelLeftSection  ,
//                                          GLabelTopsection   ,
//                                          contentSize.width  ,
//                                          contentSize.height )];
//        
//        contLabel.font = [contLabel.font fontWithSize:GLabelFontSize];  //设置 label 的字体
//        contLabel.text = [NSString stringWithFormat:@"    %@",contentString];
//        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        contLabel.numberOfLines = 0;
//        self.contSize = CGRectMake( GLabelLeftSection ,
//                                    GLabelTopsection + contentSize.height + kLabelWithLabelMargin,
//                                    GLabelMaxWidth ,
//                                    contentSize.width + contentSize.height + kLabelWithLabelMargin );
//        
//        [self addSubview:contLabel];
//    }else {
//        
//        // 非第一个内容
        UILabel *contLabel  = [[UILabel alloc]
                               initWithFrame:CGRectMake(GLabelLeftSection, self.contSize.origin.y, contentSize.width, contentSize.height)];
        
        contLabel.font = [contLabel.font fontWithSize:GLabelFontSize];
        contLabel.text = [NSString stringWithFormat:@"    %@",contentString];
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.numberOfLines = 0;
        self.contSize = CGRectMake( GLabelLeftSection ,
                                    self.contSize.origin.y + contentSize.height + kLabelWithLabelMargin,
                                    GLabelMaxWidth ,
                                    self.contSize.origin.y + contentSize.height + kLabelWithLabelMargin);
        // 最后返回最新的 self.contSize 供其他 subview 使用
        [self insertSubview:contLabel atIndex:self.subviews.count];

//    }
    
}

- (void)addImageViewWithURL:(NSString *)string
{
    
//    if ( !self.contSize.size.width ) {
//        self.contSize = CGRectMake( GLabelLeftSection ,
//                                    GLabelTopsection + GImageMaxHight + kLabelWithLabelMargin,
//                                    GLabelMaxWidth ,
//                                    GImageMaxHight + kLabelWithLabelMargin);
//        
//        // title 下面的第一个内容
//        // 创建label
//        UIImageView *imageView  = [[UIImageView alloc]
//                                   initWithFrame: CGRectMake( GLabelLeftSection,
//                                                              GLabelTopsection ,
//                                                              GImageMaxWidth   ,
//                                                              GImageMaxHight )];
//        
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        
//        [imageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            
//            NSLog(@"c") ;
//        }];
//        [self addSubview:imageView];
//        
//        
//    }else {
    
        UIImageView *imageView  = [[UIImageView alloc]
                                   initWithFrame:CGRectMake( GLabelLeftSection      ,
                                                             self.contSize.origin.y ,
                                                             GImageMaxWidth         ,
                                                             GImageMaxHight )];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:string]
                   placeholderImage:nil
                         completed:^( UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            
        }];
        [self insertSubview:imageView atIndex:self.subviews.count];
    
    // 最后返回最新的 self.contSize 供其他 subview 使用
        self.contSize = CGRectMake( GLabelLeftSection ,
                                    self.contSize.size.height + GImageMaxHight + kLabelWithLabelMargin,
                                    GImageMaxWidth ,
                                    self.contSize.size.height + GImageMaxHight + kLabelWithLabelMargin );
//    }
}




- (void)setTitleAndSubtitle
{
    
    
    // 先计算 subTitle 的 size
    CGSize subTitleSize   = [self sizeOfString:self.hometext_show_short];
    CGSize title_showSize = [self sizeOfString:self.title_show];
    
    // 1)计算 title_show 的位置
    CGRect title_showRect = CGRectMake( GLabelLeftSection ,
                                0 ,
                                GLabelMaxWidth ,
                                title_showSize.height + kLabelWithLabelMargin);
    // 2)设置title_show & 添加到 subView
    UILabel *title_showLabel = [[UILabel alloc]initWithFrame:title_showRect];
    title_showLabel.text = self.title_show;
    title_showLabel.lineBreakMode = NSLineBreakByCharWrapping;
    title_showLabel.numberOfLines = 0;
    [self addSubview:title_showLabel];
    
    
    // 设置子标题
    // 1)计算 title_show 的位置
    CGRect hometext_show_shortRect = CGRectMake( title_showRect.origin.x ,
                                       title_showRect.origin.y   ,
                                       title_showRect.size.width ,
                                       subTitleSize.height + kLabelWithLabelMargin);
    // 2)设置title_show & 添加到 subView
    UILabel *hometext_show_shortLabel = [[UILabel alloc]initWithFrame:title_showRect];
    hometext_show_shortLabel.text = self.title_show;
    hometext_show_shortLabel.lineBreakMode = NSLineBreakByCharWrapping;
    hometext_show_shortLabel.numberOfLines = 0;
    [self addSubview:hometext_show_shortLabel];
    
    
    // 最后返回最新的 self.contSize 供其他 subview 使用
    self.contSize = CGRectMake( GLabelLeftSection ,
                                hometext_show_shortRect.origin.y + subTitleSize.height + kLabelWithLabelMargin ,
                                GLabelMaxWidth ,
                                hometext_show_shortRect.origin.y + subTitleSize.height + kLabelWithLabelMargin );
    
    
    
    
//    if (IOS7_OR_LATER) {
//        titleLabel.frame = CGRectMake(GLabelLeftSection * 0.8 ,
//                           0 ,
//                           [UIScreen mainScreen].bounds.size.width - GLabelLeftSection * 0.8 * 2 ,
//                           60 );
//    }else{
//        titleLabel.frame = CGRectMake(20,0 , 260, 60);
//    }

    
    
    
}



@end
