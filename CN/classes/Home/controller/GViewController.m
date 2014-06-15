//
//  GViewController.m
//  CN
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//
#define GImageCount 5
#define limitNO @"60"
#import "GViewController.h"
#import "GTableViewCell.h"
#import "GAppDelegate.h"
#import "GTableViewCell.h"
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
#import "GDetailModel.h"
#import "GDetailViewController.h"
#import "FXLabel.h"
#import "GSettingVC.h"




@interface GViewController ()<MJRefreshBaseViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, weak  ) UIPageControl         *pageControl;
@property (nonatomic, copy  ) NSArray               *array;                  //60条首页内容
@property (nonatomic, weak  ) GStatus               *status;
@property (nonatomic, strong) NSTimer               *timer;                  //定时器
@property (nonatomic, weak  ) MJRefreshFooterView   *footer;
@property (nonatomic, weak  ) MJRefreshHeaderView   *header;
@property (nonatomic, assign) int                    page;                    //第几页
@property (nonatomic, weak  ) UIRefreshControl      *refreshControl;
@property (nonatomic, assign) CGFloat nowPoint;
@property (nonatomic, strong) UIViewController      *settingView;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, getter = isOpened) BOOL        settingViewOpened;
@end

@implementation GViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
    self.tableView.rowHeight = 240;
    
//    [self setupTableView];
    // 执行刷新操作
    [self setupRefreshView];
    
    [self setnavBarBarttom];
    
    
}

- (void)setnavBarBarttom
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(itemBeClicked)];
    [self.navigationItem setRightBarButtonItem:leftItem];
}

- (void)itemBeClicked
{
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    if (self.settingViewOpened == YES) {
//        self.tableView.frame = CGRectMake(0, 0,size.width, size.height);
//        self.settingViewOpened = NO;
//    }else if (self.settingViewOpened == NO){
//    self.tableView.frame = CGRectMake(200, 0, size.width, size.height);
//        self.settingViewOpened = YES;
//    }
    [self setupLView];
    
    [self.navigationController pushViewController:self.settingView animated:YES];
}


#pragma mark - 从数据库加载数据 从param. sid_since 到 sid_end
- (NSArray *)loadDataFromSQL:(GStatusesSid *)param
{
    return  [GStatus objectArrayWithKeyValuesArray:[GStatusCacheTool readStatuesWithParam:param]];
}

#pragma mark - 从数据库加载 xxx 条数据
- (NSArray *)loadDataFromSQLWithLimit:(NSString *)limit
{
    return  [GStatus objectArrayWithKeyValuesArray:[GStatusCacheTool readStatuesWithLimit:limit]];
}


#pragma mark - 加载旧数据
- (void)loadOldData
{
    //取出数据中最小的 mini_Sid
//    NSUserDefaults *defaults   = [NSUserDefaults standardUserDefaults];
//    NSString *mini_sid         = [defaults objectForKey:@"miniSid"];
    GStatus  *status           = self.array[self.array.count - 1];
    NSString *current_mini_sid = status.sid;
    GStatusesSid *param = [[GStatusesSid alloc]init];
//    param.sid_max   = status.sid;
    param.sid_since = [NSString stringWithFormat:@"%d",([current_mini_sid intValue] - 2)];
    param.sid_end   = [NSString stringWithFormat:@"%d",([param.sid_since intValue]- 120)];
    
        // 否则就是数据库中没有这个数据, 需要发送网络请求
        if (self.page == 0) {
            self.page = 2;
        }else {
            self.page++;
        }
        
        param.page = self.page;
        [GHTTPTool getOldStatusesFromNetwork:param success:^(NSArray *newData) {

            [self addToArrayFrom:newData];
            
            // 回到主线程刷新表格
            NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
                [self.tableView reloadData];
                [self.footer endRefreshing];
                //设置网络指示器
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
            // UI的更新需要回到主线程
            [[NSOperationQueue mainQueue] addOperation:opFailure];
            
        } failure:^(NSError *error) {
            
//            // 网络请求失败, 返回数据库中存储的最前面的60条数据
//            GStatusesSid *param = [[GStatusesSid alloc]init];
//            param.sid_max   = sidMax;
//            param.sid_since = sidMax;
//            param.sid_end   = [NSString stringWithFormat:@"%d",([param.sid_since intValue]- 120)];
//            
//            NSArray *sa = [GStatusCacheTool statuesWithParam:param];
//            self.array  = (NSMutableArray *)[GStatus objectArrayWithKeyValuesArray:sa];
            
            NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
                [MBProgressHUD showError:@"请连接互联网"];
                [self.tableView reloadData];
                [self.footer endRefreshing];
                //设置网络指示器
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
            // 回到主线程更新 UI
            
            [[NSOperationQueue mainQueue] addOperation:opFailure];
    }];
    
}

- (void)loadNewData
{
    // 取出最大sid
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString       *sidMax   = [defaults stringForKey:@"maxSid"];
    
    // 发送网络请求 请求成功回调回来

    [GHTTPTool getNewStatusesFromNetwork:[sidMax intValue] success:^(NSArray *newData) {
        
        // 回到主线程刷新表格
        NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
            // 请求成功回调回来 返回最新的数据
             self.array = newData;
             [self.tableView reloadData];
             [self.header endRefreshing];
            //设置网络指示器
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        // UI的更新需要回到主线程
        [[NSOperationQueue mainQueue] addOperation:opFailure];
        
    } failure:^(NSError *error) {
        
        // 网络请求失败, 返回数据库中存储的最前面的60条数据
        self.array = [self loadDataFromSQLWithLimit:limitNO];
        
        NSBlockOperation *opFailure = [NSBlockOperation blockOperationWithBlock:^{
            [MBProgressHUD showError:@"请连接互联网"];
            [self.tableView reloadData];
            [self.header endRefreshing];
            //设置网络指示器
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        // 回到主线程更新 UI
        [[NSOperationQueue mainQueue] addOperation:opFailure];
  
    }];
    
}


#pragma mark - Table View 的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.array.count > 0) {
        return self.array.count;
    }
	return 0;
}

#pragma mark - 设置 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    GTableViewCell *cell = [GTableViewCell cellWithTableView:tableView];
    
    if (self.array.count > 0 || self.array[indexPath.row] != nil) {
        
        GStatus *s = self.array[indexPath.row];
        cell.contLable.text  = s.hometext_show_short;
        cell.titleLable.text = s.title_show;
       


        NSURL *url = [NSURL URLWithString:s.logo];
        //判断如果 URL 中含有空格的时候, 处理返回的 nsurl 为空的BUG
        if (url == nil) {
             url = [NSURL URLWithString:[s.logo  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        [cell.imageV setImageWithURL:url placeholderImage:[UIImage imageWithName:@"4"]];
        
        cell.bottomLabel.text = [NSString stringWithFormat:@" %@ 发布于%@  %@次阅读",s.aid, s.time,s.counter];
        
    }
    
	return cell;
}

#pragma mark -  设置选中的 cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    if (self.array.count == 0) {
        return;
    }
    if (self.array[indexPath.row] == nil) {
        return;
    }
    
        GDetailViewController *GDVC = [[GDetailViewController alloc] init];
        GStatus *s = self.array[indexPath.row];
        GDetailModel *GDM = [[GDetailModel alloc]init];
        GDM.title_show = s.title_show;
        GDM.hometext_show_short = s.hometext_show_short;
        GDM.url_show   = s.url_show;
        GDM.sid        = s.sid;
        GDVC.GDM       = GDM;
        [self.navigationController pushViewController:GDVC animated:YES];
    
}

#pragma mark - 数据的更新
- (void)addToArrayFrom:(NSArray *)array
{
    
    // 请求成功回调回来 返回最新的数据
    // 将最新的数据追加到旧数据的最前面
    // 旧数据: self.statusFrames
    // 新数据: statusFrameArray
    NSMutableArray *tempArray = [NSMutableArray array];
    // 添加statusFrameArray的所有元素 添加到 tempArray中
    [tempArray addObjectsFromArray:self.array];
    // 添加self.statusFrames的所有元素 添加到 tempArray中
    [tempArray addObjectsFromArray:array];
    self.array = tempArray;
}

#pragma mark - 设置刷新控件
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

#pragma mark - 释放刷新控件
- (void)dealloc
{
    // 释放内存
    [self.header free];
    [self.footer free];
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}



- (void)setupLView
{
    self.settingView = [[GSettingVC alloc] init];
    self.settingView.view.backgroundColor = [UIColor whiteColor];
}

- (void)transF:(UIPanGestureRecognizer *)pan
{
    
    CGFloat a = [pan translationInView:self.view].x;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (self.view.frame.origin.x == 200) {
            self.nowPoint = [pan locationInView:self.view].x;
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (a < 0 && self.nowPoint == 0.0) {
            return;
        }
        
        if (a < 130 && a > 0) {
            [self moving:a];
        }else if (a >= 130 && a <= 200)
            self.tableView.frame = CGRectMake(a, 0, 320, 568);
        
        if (a < 0 && a > -200) {
            self.tableView.frame = CGRectMake(200 + a, 0, 320, 568);
        }
    }
    
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (a > 130) {
            [self moveToRight];
            
        }else {
            [self moveToZero];
            
        }
    }
    
}

- (void)moving:(CGFloat)a
{
    for (int i = 0; i < 10; i++) {
        self.tableView.frame = CGRectMake(a + 0.10, 0, 320, 568);
    }
}

- (void)moveToZero
{
//    CATransform3D transform;
//    transform = CATransform3DMakeScale(self.nowPoint, 1.f, 1.f);
//    transform = CATransform3DTranslate(transform, 1.f, 0.f, 0.f);
    self.tableView.frame = CGRectMake(0, 0, 320, 568);
    // 记录位置
    self.nowPoint = 0.0;
}

- (void)moveToRight
{
    self.tableView.frame = CGRectMake(200, 0, 320, 568);
    // 记录位置
    self.nowPoint = 200.0;
    
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
	self.tableView.rowHeight = 230;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // tableView 添加手势识别
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(transF:)];
//    [self.tableView addGestureRecognizer:pan];
//    pan.delegate = self;
    

    //阴影的颜色
    self.tableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tableView.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度
    self.tableView.layer.shadowOpacity = 2.0;
    //阴影圆角度数
    self.tableView.layer.shadowRadius = 10.0;
    
}
@end


