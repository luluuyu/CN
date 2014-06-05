//
//  GDetailModel.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDetailModel : NSObject

@property (nonatomic,copy  )NSString        *url_show;                     //文章的链接
@property (nonatomic,copy  )NSString        *title_show;                   //新闻标题
@property (nonatomic,copy  )NSString        *hometext_show_short;          //新闻子标题
@property (nonatomic,copy  )NSArray         *detailContent;                //文章内容 & 图像地址
@property (nonatomic,copy  )NSString        *sid;                          //sid







//解析所有内容
-(NSArray *)parseDetailCont:(NSString *)HTMLString;

- (void)setupContentWithURL:(NSString *)URL success:(void (^)(NSArray *arr))success
                    failure:(void (^)(NSError *error))failure;

@end
