//
//  GDetailViewController.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GTextFont [UIFont systemFontOfSize:16]

#import "GDetailViewController.h"
#import "GDetail.h"
#import "NSString+Extension.h"

@interface GDetailViewController () <UIScrollViewDelegate>


@property (nonatomic,weak)UIImageView *image;
@property (nonatomic,weak)GDetailView *view;
@property (nonatomic,assign)CGSize contSize;

@end

@implementation GDetailViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)setup
{
    
    GDetail *GD = [[GDetail alloc]init];
    
    //解析标题和正文,图片
    NSURL *url = [NSURL URLWithString:@"http://www.cnbeta.com" ];
    NSString *str = [[NSString alloc]initWithContentsOfURL: url  encoding:NSUTF8StringEncoding error:nil];
    
    NSString *titleStr = [GD parseTitle:str];
    NSString *contStr  = [GD parseDetailCont:str];
//    NSArray *imgeURL = [GD parseImageURL:self.dataItem.link];
    

    
    //计算文字的高度
    
    if (IOS7_OR_LATER) {
        CGSize textMaxSize = CGSizeMake(290, MAXFLOAT);
        self.contSize = [contStr size1WithFont:GTextFont maxSize:textMaxSize];
    }else{
        CGSize textMaxSize = CGSizeMake(290, MAXFLOAT);
        self.contSize = [contStr sizeWithFont:GTextFont constrainedToSize:textMaxSize lineBreakMode:0];
    }
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    if (IOS7_OR_LATER) {
        titleLabel.frame = CGRectMake(20,0 , 260, 60);
    }else{
        titleLabel.frame = CGRectMake(20,0 , 260, 60);
    }
    
    
    UILabel *contLable  = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, self.contSize.width, self.contSize.height)];
   
    
    
    contLable.font = [contLable.font fontWithSize:16];
    contLable.text = contStr;
    contLable.lineBreakMode = NSLineBreakByCharWrapping;
    contLable.numberOfLines = 0;
    
    titleLabel.text = titleStr;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
    
    
    //self.navigationController.navigationBarHidden = YES;
    
    
    
    
    
    CGSize mainSize =   [UIScreen mainScreen].bounds.size;
    // 相对父控件显示大小
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    if (IOS7_OR_LATER) {
        scrollView.frame = CGRectMake(0, 60,mainSize.width , mainSize.height-30);
    }else{
        scrollView.frame = CGRectMake(0, 0,mainSize.width , mainSize.height-30);
                                      }
    //scrollView 的显示范围
    scrollView.contentSize = CGSizeMake( contLable.frame.size.width, self.contSize.height + 90);
    
    
    
    
    [scrollView addSubview:titleLabel];
    [scrollView addSubview:contLable];
       
    [self.view addSubview:scrollView];
        
    
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    GDetailView *view = [[GDetailView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    [self setup];
    
    
}




- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.view = nil;
   
    
}




@end
