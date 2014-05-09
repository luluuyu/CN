//
//  MasterViewController.m
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//
#define MJImageCount 5
#import "MasterViewController.h"
#import "GAppDelegate.h"
#import "GDetailViewController.h"
#import "GTableViewCell.h"
#import "GMasterParse.h"
#import "GParseImage.h"




@interface MasterViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
	NSArray *_dataItems;
}
@property (nonatomic, weak) GTableViewCell *tableViewCell;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (weak, nonatomic)  UIPageControl *pageControl;
@property (nonatomic, copy) NSString *allcontent;                               //全部首页内容
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MasterViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	GAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,-130, 320, 130)];
    self.scrollView = scrollView;
    self.scrollView.delegate =self;
    [self setImage:scrollView];
    self.tableView.contentInset = UIEdgeInsetsMake(130, 0, 0, 0);
    self.tableView.rowHeight = 150;
    [self.tableView addSubview:self.scrollView];
    [self.view addSubview:self.tableView];
    
    
 
}

/*
- (void)loadData
{
    NSURL *url = [NSURL URLWithString:@"http://www.cnbeta.com" ];
    NSString *Xml = [[NSString alloc]initWithContentsOfURL: url  encoding:NSUTF8StringEncoding error:nil];
    
    NSRange headRange = [Xml rangeOfString:@"<div class=\"items_area\">"];
    Xml = [Xml substringFromIndex:headRange.location];
    
    //删掉尾部不必要部分
    NSRange footerRange = [Xml rangeOfString:@"<div class=\"items_area\"></div>"];
    Xml = [Xml substringToIndex:footerRange.location];
    
    self.allcontent = Xml;
    
}
*/








#pragma mark - Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GTableViewCell *cell = [GTableViewCell cellWithTableView:tableView];
    GMasterParse *GD = [[GMasterParse alloc]init];
    self.allcontent = [GD parseTitle:self.allcontent];
    cell.titleLable.text = GD.title_show;
    cell.contLable.text = GD.hometext_show_short;
    
#warning 图片功能需要重新做一下
//    NSArray *imageArray = [GD parseImageURL:self.allcontent];
//    NSLog(@"@%@" ,imageArray );
//    GParseImage *asynImgView = [[GParseImage alloc]initWithFrame:cell.imageV.frame];
//    asynImgView.placeholderImage = [UIImage imageNamed:@"place.png"];
//    asynImgView.imageURL = imageArray[a];
//    
//    cell.imageV.image = asynImgView.image;
    

  
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!self.detailViewController)
		self.detailViewController = [[GDetailViewController alloc] init];

    
	[self.navigationController pushViewController:self.detailViewController animated:YES];
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
    for (int i = 0; i<MJImageCount; i++) {
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
    CGFloat contentW = MJImageCount * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.delegate = self;
    
    // 5.设置pageControl的总页数
    self.pageControl.numberOfPages = MJImageCount;
    
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
    if (self.pageControl.currentPage == MJImageCount - 1) {
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

