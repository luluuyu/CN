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
@property (nonatomic,copy  )NSString        *detailContent;
@property (nonatomic,copy  )NSString        *URLArray;
@property (nonatomic,copy  )NSMutableArray  *imageArray;





//解析图片
-(NSMutableArray *)parseImageURL:(NSString *)HTMLString;
//解析所有内容
-(NSString *)parseDetailCont:(NSString *)HTMLString;

- (void)setupContentWithURL:(NSString *)URL success:(void (^)(NSString *str))success
                    failure:(void (^)(NSError *error))failure;

@end
