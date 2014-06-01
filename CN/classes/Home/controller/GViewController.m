//
//  GViewController.m
//  CN
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GImageCount 5
#import "GViewController.h"
#import "GTableViewCell.h"
#import "GAppDelegate.h"
#import "GDetailViewController.h"
#import "GTableViewCell.h"
#import "GMasterParse.h"
#import "GParseImage.h"
#import "GHTTPTool.h"
#import "GStatusesSid.h"
#import "GStatusCacheTool.h"
#import "MJExtension.h"
#import "GStatus.h"
#import "UIImage+UIImage_G.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"



@interface GViewController ()<MJRefreshBaseViewDelegate>


@property (nonatomic, weak  ) UIPageControl       *pageControl;
@property (nonatomic, copy  ) NSArray             *array;                  //60条首页内容
@property (nonatomic, weak  ) GStatus             *status;
@property (nonatomic, strong) NSTimer             *timer;                  //定时器
@property (nonatomic, weak  ) MJRefreshFooterView *footer;
@property (nonatomic, weak  ) MJRefreshHeaderView *header;
@property (nonatomic, weak  ) UIRefreshControl    *refreshControl;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

@end

@implementation GViewController



- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.rowHeight = 300;
    
    
    // 取出最大sid
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sidMax = [defaults stringForKey:@"maxSid"];
    // 加载数据 判断是否首次打开
    if (sidMax) {
        [self loadDataFromSQL:sidMax];
    }

    // 执行刷新操作
    [self setupRefreshView];
}

- (void)setupRefreshView
{
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    // 自动进入刷新状态
    [header beginRefreshing];
    self.header = header;
    
    
    
    // 2.上拉刷新(上拉加载更多数据)
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    self.footer = footer;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        IWLog(@"refreshing.....");
    };
    
    
    
}

- (void)dealloc
{
    // 释放内存
    [self.header free];
    [self.footer free];
}




#pragma mark - 刷新控件开始刷新的时候调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉刷新
        
        [self loadOldData];
    } else { // 下拉刷新
        [self loadNewData];
        
    }
}

// 软件刚刚被打开(除了首次以外), 首先先把数据库里面的数据加载进来
- (void)loadDataFromSQL:(NSString *)sidMax
{
    GStatusesSid *param = [[GStatusesSid alloc]init];
    param.sid_max   = [sidMax intValue];
    param.sid_since = [sidMax intValue];
    param.sid_end   = param.sid_since - 62;
    
    NSArray *sa = [GStatusCacheTool statuesWithParam:param];
    self.array  = [GStatus objectArrayWithKeyValuesArray:sa];
 
}

- (void)loadOldData
{
    NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
        //判断软件是不是首次被打开
//        if (sidMax) {
//            [self loadDataFromSQL:sidMax];
//        }
        [MBProgressHUD showError:@"亲,没网啊!!"];
        [self.footer endRefreshing];
    }];
    // 回到主线程更新 UI
    [[NSOperationQueue mainQueue] addOperation:opFailure];
}

- (void)loadNewData
{
    // 取出最大sid
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sidMax = [defaults stringForKey:@"maxSid"];
    
    // 发送网络请求 请求成功回调回来
    GHTTPTool * a = [[GHTTPTool alloc]init];
    [a getStatusesFromNetwork:[sidMax intValue] success:^(NSArray *newData) {
        
        // 请求成功回调回来 返回最新的数据
        self.array = newData;
        
        // 回到主线程刷新表格
        NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
             [self.tableView reloadData];
             [self.header endRefreshing];
        }];
        // UI的更新需要回到主线程
        [[NSOperationQueue mainQueue] addOperation:opFailure];
        
    } failure:^(NSError *error) {
        
        // 网络请求失败, 返回数据库中存储的最前面的60条数据
        GStatusesSid *param = [[GStatusesSid alloc]init];
        param.sid_max   = [sidMax intValue];
        param.sid_since = [sidMax intValue];
        param.sid_end   = param.sid_since - 124;
        
        NSArray *sa = [GStatusCacheTool statuesWithParam:param];
        self.array  = [GStatus objectArrayWithKeyValuesArray:sa];
        
        NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
            //判断软件是不是首次被打开
            if (sidMax) {
                [self loadDataFromSQL:sidMax];
            }
            [MBProgressHUD showError:@"亲,没网啊!!"];
            [self.header endRefreshing];
        }];
        // 回到主线程更新 UI
        [[NSOperationQueue mainQueue] addOperation:opFailure];
  
    }];
    
}






#pragma mark - Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.array.count > 0) {
        return self.array.count;
    }
	return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    GTableViewCell *cell = [GTableViewCell cellWithTableView:tableView];
    
    if (self.array > 0) {
        GStatus *s = self.array[indexPath.row];
        cell.contLable.text  = s.hometext_show_short;
        cell.titleLable.text = s.title_show;
        [cell.imageV setImageWithURL:[NSURL URLWithString:s.logo] placeholderImage:[UIImage imageWithName:@"3.jpg"]];
        cell.bottomLabel.text = [NSString stringWithFormat:@" %@ 发布于%@   %@ 次阅读",s.aid, s.time,s.counter];
        cell.backgroundColor = [UIColor colorWithRed:251 green:251 blue:251 alpha:0];
        
    }
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	if (!self.detailViewController)
//		self.detailViewController = [[GDetailViewController alloc] init];
//	DataItem *object = _dataItems[indexPath.row];
//    
//	
//	[self.navigationController pushViewController:self.detailViewController animated:YES];
}






@end


