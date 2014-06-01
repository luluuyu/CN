//
//  news.h
//  测试
//
//  Created by AlfieL on 14-5-29.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GStatus : NSObject
@property (nonatomic,copy  )NSString        *sid;                          //sid
@property (nonatomic,copy  )NSString        *aid;                          //作者
@property (nonatomic,copy  )NSString        *title_show;                   //新闻标题
@property (nonatomic,copy  )NSString        *hometext_show_short;          //新闻子标题
@property (nonatomic,copy  )NSString        *logo;                         //logo
@property (nonatomic,copy  )NSString        *url_show;                     //文章链接
@property (nonatomic,copy  )NSString        *counter;                      //
@property (nonatomic,copy  )NSString        *comments;                     //
@property (nonatomic,copy  )NSString        *score;                        //
@property (nonatomic,copy  )NSString        *ratings;                      //
@property (nonatomic,copy  )NSString        *score_story;                  //
@property (nonatomic,copy  )NSString        *ratings_story;                //
@property (nonatomic,copy  )NSString        *rate_sum;                     //
@property (nonatomic,copy  )NSString        *dig;                          //
@property (nonatomic,copy  )NSString        *time;                         //发表时间


@end
