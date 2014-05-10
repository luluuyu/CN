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



@interface GViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate> {
	NSArray *_dataItems;
}
@property (nonatomic, weak) GTableViewCell *tableViewCell;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (weak, nonatomic)  UIPageControl *pageControl;
@property (nonatomic, copy) NSArray *array;                              //60条首页内容
@property (nonatomic, weak) GStatus *status;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) MJRefreshFooterView *footer;
@property (nonatomic, weak) MJRefreshHeaderView *header;

@end

@implementation GViewController



- (void)viewDidLoad
{
	[super viewDidLoad];
	
    [self setupTableView];
    
    [self setupScrollPic];

    [self loadData];
}

- (void)setupScrollPic
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,-130, 320, 130)];
    self.scrollView = scrollView;
    self.scrollView.delegate =self;
    [self setImage:scrollView];
    self.tableView.contentInset = UIEdgeInsetsMake(130, 0, 0, 0);
    self.tableView.rowHeight = 150;
    [self.tableView addSubview:self.scrollView];
    [self.view addSubview:self.tableView];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
}

- (void)refresh
{
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    // 自动进入刷新状态
    [header beginRefreshing];
    self.header = header;

}

- (void)loadData
{
    //取出最大sid
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sidMax = [defaults stringForKey:@"maxSid"];
    
    // 先发送网络请求
    [GHTTPTool getStatusesFromNetwork:[sidMax intValue]];
    
    GStatusesSid *param = [[GStatusesSid alloc]init];
    param.sid_max   = [sidMax intValue];
    param.sid_since = [sidMax intValue];
    param.sid_end   = param.sid_since - 124;
    
    NSArray *sa = [GStatusCacheTool statuesWithParam:param];
    self.array  = [GStatus objectArrayWithKeyValuesArray:sa];
    
}



- (void)onGetResponse
{
	   
	[self.tableView reloadData];
}


#pragma mark - Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTableViewCell *cell = [GTableViewCell cellWithTableView:tableView];
    if (self.array) {
        GStatus *s = self.array[indexPath.row];
        cell.contLable.text  = s.hometext_show_short;
        cell.titleLable.text = s.title_show;
        cell.imageV.image = [UIImage imageWithName:@"3.jpg"];
        
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



#pragma mark - 代理方法
/**
 *  当scrollView正在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = page;
}

/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}

#pragma scrollView
- (void)setImage:(UIScrollView *)scrollView
{
    
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    // 1.添加5张图片到scrollView中
    for (int i = 0; i<GImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置frame
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"img_0%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 2.设置内容尺寸
    CGFloat contentW = GImageCount * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.delegate = self;
    
    // 5.设置pageControl的总页数
    self.pageControl.numberOfPages = GImageCount;
    
    // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
    [self addTimer];
    
    
    
}


/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage
{
    // 1.增加pageControl的页码
    int page = 0;
    if (self.pageControl.currentPage == GImageCount - 1) {
        page = 0;
    } else {
        page = (int)self.pageControl.currentPage + 1;
    }
    
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

@end


