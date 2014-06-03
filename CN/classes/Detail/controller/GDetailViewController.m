//
//  GDetailViewController.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GTextFont [UIFont systemFontOfSize:16]

#import "GDetailViewController.h"
#import "GDetailModel.h"
#import "NSString+Extension.h"
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
    self.navigationItem.title = self.GDM.title_show;
    
    // 设置显示的内容
    [self.GDM setupContentWithURL:self.GDM.url_show success:^(NSString *str) {
        if (str) {
            
            self.GDM.detailContent = str;

            // 回到主线程 更新 UI
            NSBlockOperation *opSuccess = [NSBlockOperation blockOperationWithBlock:^{
                
                
        }];
            
            [[NSOperationQueue mainQueue] addOperation:opSuccess];
        }
    } failure:^(NSError *error) {
        
    }];

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
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    if (IOS7_OR_LATER) {
        titleLabel.frame = CGRectMake(20,0 , 260, 60);
    }else{
        titleLabel.frame = CGRectMake(20,0 , 260, 60);
    }
    
    
    UILabel *contLable  = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, self.contSize.width, self.contSize.height)];
    return contSize;
}
- (void)setupView{
    
    

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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    GDetailView *view = [[GDetailView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = view;
}





- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.view = nil;
   
    
}




@end
