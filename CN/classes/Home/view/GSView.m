//
//  MJViewController.m
//  04-图片轮播器
//
//  Created by apple on 14-3-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#define MJImageCount 5

#import "GSView.h"

@interface GSView () <UIScrollViewDelegate>

@property (weak, nonatomic)  UIPageControl *pageControl;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation GSView




- (GSView *)setImage:(GSView *)scrollView
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
    self.scrollView.backgroundColor = [UIColor redColor];
    return self.scrollView;
    
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
@end
