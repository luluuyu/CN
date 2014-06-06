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
@property (nonatomic, copy  )NSArray         *arr;
/** 新闻标题 */
@property (nonatomic, assign)CGRect           contSize;
/** 新闻标题 */
@property (nonatomic,copy   )NSString        *title_show;
/** 新闻标题 */
@property (nonatomic,copy   )NSString        *hometext_show_short;
@end
