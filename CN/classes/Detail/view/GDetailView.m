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
#define GLabelTopsection         (IOS7_OR_LATER? 20:20)         // 首个 subView 上部预留边距
#define GTopImageViewH           100        // 顶部的 imageView



#import "GDetailView.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "FXLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface GDetailView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView      *imageView;
@property (nonatomic, strong)UIView          *backView;
@property (nonatomic, strong) NSMutableArray  *potosArray;
@property (nonatomic, strong) UIImageView      *logoView;
@property (nonatomic, assign) int              i;


@end


@implementation GDetailView

// 重写 arr 的 set 方法, 设置 View
- (void)setArr:(NSArray *)arr
{
     _arr = arr;
    
    
    if (self.backView == nil) {
        
        self.backView = [[UIView alloc]init];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        
        if (IOS7_OR_LATER) {
            self.backView.backgroundColor = GDetailbackGroundColor;
        }
    }
    
    // 初始化相册数组
    if (self.potosArray == nil) {
        NSMutableArray *ma = [NSMutableArray array];
        self.potosArray = ma;
    }
    
    [self setTitleAndSubtitle];
    
    // 处理 arr (设置 view 的显示)
 
    [self processArr:arr];
    
    [self setupTopImageView];
    
    self.userInteractionEnabled = YES;
    
   
    
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



#pragma 设置 label
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
        [self.backView addSubview:contLabel];
    
    contLabel.userInteractionEnabled = YES;
    

    
}

- (void)addImageViewWithURL:(NSString *)url
{
        // 先将这个 imageviewURL 添加到数组
    
     [self.potosArray addObject:[NSString stringWithFormat:@"%@",url]];
    
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
    [self addSubview:imageView];
    
    //设置 image
    imageView.userInteractionEnabled = YES;
    
    // 添加监听点击时间
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [imageView addGestureRecognizer:tap];
    [self.logoView addSubview:imageView];
    imageView.tag = self.i++;

    tap.delegate = self;

    // 最后返回最新的 self.contSize 供其他 subview 使用
    self.contSize = CGRectMake( GLabelLeftSection ,
                                self.contSize.size.height + GImageMaxHight + kimageWithimageMargin,
                                GImageMaxWidth ,
                                self.contSize.size.height + GImageMaxHight + kimageWithimageMargin );
    
    

}



/**
 *  大标题  &  子标题
 */
- (void)setTitleAndSubtitle
{
    
    
    // 先计算 subTitle 的 size
    CGSize subTitleSize   = [self sizeOfString:self.hometext_show_short withFont:GHomeSTextFont];
    CGSize title_showSize = [self sizeOfString:self.title_show withFont:[UIFont boldSystemFontOfSize:20]];
    
    // 1)计算 title_show 的位置

    
    // 2)设置title_show & 添加到 subView
    CGRect title_showLabelCGRect = CGRectMake(GLabelLeftSection ,
                                              GLabelTopsection  ,
                                              GLabelMaxWidth    ,
                                              title_showSize.height + kimageWithimageMargin);
    FXLabel *title_showLabel = [[FXLabel alloc]initWithFrame:title_showLabelCGRect];
    title_showLabel.font = [UIFont boldSystemFontOfSize:20];
    title_showLabel.text = self.title_show;
    title_showLabel.lineBreakMode = NSLineBreakByCharWrapping;
    title_showLabel.numberOfLines = 0;
    title_showLabel.textColor = [UIColor colorWithRed: 4/255.0 green:40/255.0 blue:150/255.0 alpha:1];
    title_showLabel.backgroundColor = [UIColor clearColor];
    title_showLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    title_showLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.35f];
    title_showLabel.shadowBlur = 3.0f;
    [self.backView addSubview:title_showLabel];
    title_showLabel.userInteractionEnabled =YES;
    
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
    // 最后返回最新的 self.contSize 供其他 subview 使用
    self.contSize = CGRectMake( GLabelLeftSection ,
                                hometext_show_shortRect.origin.y + subTitleSize.height + kLabelWithLabelMargin ,
                                GLabelMaxWidth ,
                                hometext_show_shortRect.origin.y + subTitleSize.height + kLabelWithLabelMargin );

    UIImageView * backView = [[UIImageView alloc]initWithFrame:
                              CGRectMake(0,
                                         hometext_show_shortRect.origin.y - 3,
                                         [UIScreen mainScreen].bounds.size.width,
                                         hometext_show_shortRect.size.height + 5)];
    if (IOS7_OR_LATER) {
        backView.image = [UIImage resizeImageWithImageName:@"3" left:0.5 top:0.5];

    }else {
        backView.image = [UIImage resizeImageWithImageName:@"wihte" left:0.5 top:0.5];
       
    }
    
    [self.backView addSubview:backView];
    [self.backView addSubview:hometext_show_shortLabel];

}

- (void)setupTopImageView
{
    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.frame = CGRectMake(0 , 64 , 320, 100);
    
//    self.imageView.backgroundColor = [UIColor colorWithWhite:255.0/255.0 alpha:0.5];
    
    [self.backView addSubview:self.imageView];
    
    self.backView.userInteractionEnabled = YES;
    self.imageView.userInteractionEnabled = YES;

    
}


#pragma 图片点击之后打开图片浏览器
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSArray *arr_url = (NSArray *)self.potosArray;
    
    int count = (int)arr_url.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = arr_url[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.logoView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
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


@end
