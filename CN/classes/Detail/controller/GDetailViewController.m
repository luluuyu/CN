//
//  GDetailViewController.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#define ScrollViewH (IOS7_OR_LATER ? 10 :54)
#import "GDetailViewController.h"
#import "GDetailModel.h"
#import "GStastusDetailCacheTool.h"
#import "MBProgressHUD+MJ.h"


@interface GDetailViewController () <UIScrollViewDelegate>


@property (nonatomic,weak   )UIImageView       *image;
@property (nonatomic,weak   )GDetailView       *view;
@property (nonatomic,assign )CGSize             contSize;


@end

@implementation GDetailViewController



#pragma mark  初始化相关布局

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = GDetailbackGroundColor;
    self.navigationItem.title = self.GDM.title_show;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (IOS7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 设置显示的内容
    if ([GStastusDetailCacheTool isStatusAlreadyIn:[self.GDM.sid intValue]])
    {
        NSArray *arr = [GStastusDetailCacheTool readStatuesWithSid:[self.GDM.sid intValue]];
        [self setupGDetailViewWithData:arr];
    } else {
        [self initWithContent];
    }
}

#pragma mark 加载数据
// 加载数据
- (void)initWithContent
{
    [self.GDM setupContentWithURL:self.GDM.url_show success:^(NSArray *arr) {
        
        if (arr) {
            
            [self setupGDetailViewWithData:arr];
            // 存储数据
            NSDictionary *tempDict = @{@"sid": self.GDM.sid, @"sta": arr};
            [GStastusDetailCacheTool addStatus:tempDict];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请连接互联网"];
    }];
}

- (void)setupGDetailViewWithData:(NSArray *)arr
{
    CGRect screen  = [UIScreen mainScreen].bounds;
    GDetailView  *GDV = [[GDetailView alloc]initWithFrame:CGRectMake(0, 0, screen.size.width,screen.size.height - ScrollViewH)];
    
    // 传递 title 数据
    GDV.title_show = self.GDM.title_show;
    GDV.hometext_show_short = self.GDM.hometext_show_short;
    // 传递内容数据
    GDV.arr = arr;
    GDV.contentSize = CGSizeMake(self.view.bounds.size.width, GDV.contSize.size.height);
    GDV.backgroundColor = GDetailbackGroundColor;
    [self.view addSubview:GDV];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    self.view = nil;
   
    
}




@end
