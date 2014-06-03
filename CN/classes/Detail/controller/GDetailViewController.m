//
//  GDetailViewController.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//


#import "GDetailViewController.h"
#import "GDetailModel.h"

#import "MBProgressHUD+MJ.h"

@interface GDetailViewController () <UIScrollViewDelegate>


@property (nonatomic,weak   )UIImageView       *image;
@property (nonatomic,weak   )GDetailView       *view;
@property (nonatomic,assign )CGSize             contSize;


@end

@implementation GDetailViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.GDM.title_show;
    
    // 设置显示的内容
    [self initWithContent];

}

// 加载数据
- (void)initWithContent
{
    [self.GDM setupContentWithURL:self.GDM.url_show success:^(NSArray *arr) {
        
        if (arr) {
            [self setupGDetailViewWithData:arr];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"        请连接互联网        "];
    }];
}

- (void)setupGDetailViewWithData:(NSArray *)arr
{
        CGRect screen  =[UIScreen mainScreen].bounds;
    GDetailView  *GDV = [[GDetailView alloc]initWithFrame:CGRectMake(0, 0, 320,screen.size.height-44)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    GDV.arr = arr;
    GDV.contentSize = CGSizeMake(self.view.bounds.size.width, GDV.contSize.size.height);
    [self.view addSubview:GDV];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}





- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.view = nil;
   
    
}




@end
