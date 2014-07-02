//
//  GDetailViewController.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#define ScrollViewH (IOS7_OR_LATER ? 10 :54)
#define BottomViewH (IOS7_OR_LATER ? 40 :0)

#import "GDetailViewController.h"
#import "GDetailModel.h"
#import "GStastusDetailCacheTool.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"

@interface GDetailViewController () <UIScrollViewDelegate>


@property (nonatomic,strong   )UIImageView       *imageView;
@property (nonatomic,weak   )GDetailView       *detailview;
@property (nonatomic,assign )CGSize             contSize;


@end

@implementation GDetailViewController



#pragma mark  初始化相关布局

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = GDetailbackGroundColor;
    self.navigationItem.title = @"cnBetter";
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
        //设置网络指示器
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    // 设置分享按钮
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    
    
}

#pragma  share
- (void)share
{
    NSString *str = [NSString stringWithFormat:@"%@.   http://www.cnbeta.com%@",self.GDM.title_show,self.GDM.url_show];

    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"539c40b356240ba62f0aca62"
                                      shareText:str
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
}

- (void)initimageView
{
    
    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.frame = CGRectMake(0 , imageViewY , 320, 100);
    
    self.imageView.image = [UIImage resizeImageWithImageName:@"snip" left:0.5 top:0.1];
    
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;

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
            //设置网络指示器
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请连接互联网"];
        //设置网络指示器
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)setupGDetailViewWithData:(NSArray *)arr
{
    CGRect screen  = [UIScreen mainScreen].bounds;
    GDetailView  *GDV = [[GDetailView alloc]initWithFrame:CGRectMake( 0, 0, screen.size.width,screen.size.height - ScrollViewH)];
    
    // 传递 title 数据
    GDV.title_show = self.GDM.title_show;
    GDV.hometext_show_short = self.GDM.hometext_show_short;
    // 传递内容数据
    GDV.arr = arr;
    GDV.delegate = self;
    // 滚动范围
    GDV.contentSize = CGSizeMake(self.view.bounds.size.width, GDV.contSize.size.height + BottomViewH);
    GDV.backgroundColor = GDetailbackGroundColor;
    [self.view addSubview:GDV];
    GDV.userInteractionEnabled = YES;
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    self.view = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   
}

#pragma detailView 的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.bounds.origin.y < 0) {
        self.imageView.frame = CGRectMake(0, -scrollView.bounds.origin.y + imageViewY , 320, 100);
    }else {
        self.imageView.frame = CGRectMake(0, -scrollView.bounds.origin.y * 0.4 + imageViewY , 320, 100);
    }
}


@end
