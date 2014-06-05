//
//  GDetailView.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDetailView : UIScrollView
/** 新闻标题 */
@property (nonatomic, copy  )NSArray         *arr;                            //新闻子标题
/** 新闻标题 */
@property (nonatomic, assign)CGRect           contSize;                       //新闻子标题
/** 新闻标题 */
@property (nonatomic,copy   )NSString        *title_show;                     //新闻子标题
/** 新闻标题 */
@property (nonatomic,copy   )NSString        *hometext_show_short;            //新闻子标题
@end
