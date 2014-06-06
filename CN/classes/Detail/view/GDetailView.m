//
//  GDetailView.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GLabelTextFont          [UIFont systemFontOfSize:GLabelFontSize]
#define GLabelFontSize           18
#define GHomeSTextFont          [UIFont systemFontOfSize:GHomeSFontSize + 1]
#define GHomeSFontSize           15
#define GLabelMaxWidth           300        // label 最大的宽度
#define GImageMaxWidth           280        // imageView 最大的宽度
#define GImageMaxHight           200        // imageView 最大的 高度
#define GTitle_showHight         60
#define kLabelWithLabelMargin    20         // label 与 label 之间的间距
#define kimageWithimageMargin    10         // label 与 label 之间的间距
#define miniLabelTextLimited     5          // label 显示的最小文字限制
#define GLabelLeftSection        13         // label 的左边距
#define GLabelTopsection         (IOS7_OR_LATER?70:10)         // 首个 subView 上部预留边距



#import "GDetailView.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "FXLabel.h"
@interface GDetailView ()



@end


@implementation GDetailView

// 重写 arr 的 set 方法, 设置 View
- (void)setArr:(NSArray *)arr
{
     _arr = arr;
    
    [self setTitleAndSubtitle];
    
    // 处理 arr (设置 view 的显示)
 
    [self processArr:arr];
    
    
    
}

// 处理 arr (设置 view 的显示)
- (void)processArr:(NSArray *)arr
{
    
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
- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font
{
    CGSize contSize;
    if (IOS7_OR_LATER) {
        CGSize textMaxSize = CGSizeMake(GLabelMaxWidth, MAXFLOAT);
        contSize = [string sizeWithFont:font maxSize:textMaxSize];
    }else{
        CGSize textMaxSize = CGSizeMake(GLabelMaxWidth, MAXFLOAT);
        contSize = [string sizeWithFont:font constrainedToSize:textMaxSize lineBreakMode:0];
    }
    return contSize;
}



- (void)addLabelWithString:(NSString *)contentString
{
    // 先计算size
    CGSize contentSize = [self sizeOfString:contentString withFont:GLabelTextFont];
        // 非第一个内容
        UILabel *contLabel  = [[UILabel alloc]initWithFrame:
                               CGRectMake(GLabelLeftSection       ,
                                          self.contSize.origin.y  ,
                                          contentSize.width       ,
                                          contentSize.height )];
        
        contLabel.font = [contLabel.font fontWithSize:GLabelFontSize];
        contLabel.text = [NSString stringWithFormat:@"     %@",contentString];
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.numberOfLines = 0;
        self.contSize = CGRectMake( GLabelLeftSection ,
                                    self.contSize.origin.y + contentSize.height + kLabelWithLabelMargin,
                                    GLabelMaxWidth ,
                                    self.contSize.origin.y + contentSize.height + kLabelWithLabelMargin);
        // 最后返回最新的 self.contSize 供其他 subview 使用
        [self insertSubview:contLabel atIndex:self.subviews.count];

    
}

- (void)addImageViewWithURL:(NSString *)url
{
        CGRect imageViewCGRect = CGRectMake( GLabelLeftSection + 6  ,
                                             self.contSize.origin.y ,
                                             GImageMaxWidth         ,
                                             GImageMaxHight );

        UIImageView *imageView  = [[UIImageView alloc]
                                   initWithFrame:imageViewCGRect];
    imageView.backgroundColor = GDetailbackGroundColor;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:url]
                  placeholderImage:[UIImage imageWithName:@"4"]
                         completed:^( UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        [self insertSubview:imageView atIndex:self.subviews.count];
    
        // 最后返回最新的 self.contSize 供其他 subview 使用
        self.contSize = CGRectMake( GLabelLeftSection ,
                                    self.contSize.size.height + GImageMaxHight + kimageWithimageMargin,
                                    GImageMaxWidth ,
                                    self.contSize.size.height + GImageMaxHight + kimageWithimageMargin );

}




- (void)setTitleAndSubtitle
{
    
    
    // 先计算 subTitle 的 size
    CGSize subTitleSize   = [self sizeOfString:self.hometext_show_short withFont:GHomeSTextFont];
    CGSize title_showSize = [self sizeOfString:self.title_show withFont:[UIFont boldSystemFontOfSize:20]];
    
    // 1)计算 title_show 的位置

    
    // 2)设置title_show & 添加到 subView
    CGRect title_showLabelCGRect = CGRectMake(GLabelLeftSection ,
               GLabelTopsection ,
               GLabelMaxWidth ,
               title_showSize.height + kimageWithimageMargin);
    UILabel *title_showLabel = [[UILabel alloc]initWithFrame:title_showLabelCGRect];
    title_showLabel.backgroundColor = GDetailbackGroundColor;
    title_showLabel.font = [UIFont boldSystemFontOfSize:20];
    title_showLabel.text = self.title_show;
    title_showLabel.lineBreakMode = NSLineBreakByCharWrapping;
    title_showLabel.numberOfLines = 0;
    title_showLabel.textColor = [UIColor colorWithRed: 4/255.0 green:40/255.0 blue:150/255.0 alpha:1];
    title_showLabel.backgroundColor = GDetailbackGroundColor;
    [self addSubview:title_showLabel];
    
    
    // 设置子标题
    // 1)计算 hometext_show_short 的位置
    CGRect hometext_show_shortRect = CGRectMake(
                                                title_showLabelCGRect.origin.x ,
                                                title_showLabelCGRect.origin.y + title_showSize.height*1.3 + kLabelWithLabelMargin,
                                                title_showLabel.frame.size.width ,
                                                subTitleSize.height);
    
    // 2)设置hometext_show_short & 添加到 subView
    
    UILabel *hometext_show_shortLabel = [[UILabel alloc]initWithFrame:hometext_show_shortRect];
    hometext_show_shortLabel.font = [hometext_show_shortLabel.font fontWithSize:GHomeSFontSize];
    hometext_show_shortLabel.text = [NSString stringWithFormat:@"    %@",self.hometext_show_short];
    hometext_show_shortLabel.lineBreakMode = NSLineBreakByWordWrapping;
    hometext_show_shortLabel.numberOfLines = 0;
    hometext_show_shortLabel.backgroundColor = GDetailbackGroundColor;

    [self addSubview:hometext_show_shortLabel];
    
    
    // 最后返回最新的 self.contSize 供其他 subview 使用
    self.contSize = CGRectMake( GLabelLeftSection ,
                                hometext_show_shortRect.origin.y + subTitleSize.height + kLabelWithLabelMargin ,
                                GLabelMaxWidth ,
                                hometext_show_shortRect.origin.y + subTitleSize.height + kLabelWithLabelMargin );
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(
                                                               0,
                                                               hometext_show_shortRect.origin.y - 3,
                                                               [UIScreen mainScreen].bounds.size.width,
                                                               hometext_show_shortRect.size.height + 5)];
    backView.backgroundColor = [UIColor colorWithRed:235/255 green:235/255 blue:235/255 alpha:0.05];
    
    [self addSubview:backView];
    
    
    
    

    
    
    
}



@end
