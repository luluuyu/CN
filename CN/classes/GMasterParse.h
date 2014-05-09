//
//  GMasterParse.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GMasterParse : NSObject

@property (nonatomic,assign)int              sid;                          //sid
@property (nonatomic,copy  )NSString        *title_show;                   //新闻标题
@property (nonatomic,copy  )NSString        *hometext_show_short;          //新闻子标题
@property (nonatomic,copy  )NSString        *URLArray;                     //logo
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
@property (nonatomic,copy  )NSString        *contStr;                      //概述
@property (nonatomic,copy  )NSString        *detailStr;                    //正文

@property (nonatomic,strong)NSArray         *subContArray;
@property (nonatomic,copy  )NSString        *allcontent;                   //全部首页内容
                        //新闻链接
@property (nonatomic,assign)int              parseTag;

@property (strong, nonatomic) NSMutableArray *imageArray;


//-(void)initData;
//解析Title
-(NSString *)parseTitle:(NSString *)title;
//解析网页副标题
-(NSString *)parseSubTitle:(NSString *)subTitle;
//解析图片地址
-(NSMutableArray *)parseImageURL:(NSString *)imageStr;
//解析内容
-(NSString *)parseDetailCont:(NSString *)DetailContStr;
//解析所有内容
-(NSArray *)parseAllSubCont:(NSString *)DetailContStr;



@end
/*
 "sid":                     "295861",
 "aid":                     "raymon725",
 "title_show":              "腾讯与香港运营商合作 来港游客可享受免费WiFi",
 
 "hometext_show_short":     "近日，腾讯和香港运营商PCCW-HKT达成一项合作协议，微信用户添加PCCW-HKT微信官号，来港旅游时就即可享有3天的免费                   WiFi。据悉，PCCW-HKT在香港有超过1.3万个WiFi 热点，是全港最大的WiFi 服务营运商。该活动将从5月26日开始，截止到6月15日。",
 
 "logo":                    "http://static.cnbetacdn.com/newsimg/2014/0527/31_1jx1SaHki.jpg_180x132.jpg",
 
 "url_show":                "/articles/295861.htm",
 "counter":                 "6898",
 "comments":                "33",
 "score":                   "-15",
 "ratings":                 "13",
 "score_story":             "-5",
 "ratings_story":           "11",
 "rate_sum":                 24,
 "dig":                     "6",
 "time":                    "2014-05-27 13:07:37"}
 
 */






