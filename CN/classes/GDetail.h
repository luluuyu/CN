//
//  GDetail.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDetail : NSObject

@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *hometext_show_short;
@property (nonatomic,strong)NSString *contStr;
@property (nonatomic,strong)NSString *detailStr;
@property (nonatomic,copy  )NSString *URLArray;
@property (nonatomic,strong)NSArray  *subContArray;


@property (strong, nonatomic) NSMutableArray *imageArray;
//@property (strong, nonatomic) NSMutableArray *contArray;
//@property (strong, nonatomic) NSArray *array;


//-(void)initData;
//解析Title
-(NSString *)parseTitle:(NSString *)htmlString;
//解析网页副标题
-(NSString *)parseSubTitle:(NSString *)htmlString;
//解析图片
-(NSMutableArray *)parseImageURL:(NSString *)htmlString;
//解析内容
-(NSString *)parseDetailCont:(NSString *)htmlString;
//解析所有内容
-(NSArray *)parseAllSubCont:(NSString *)htmlString;



@end
