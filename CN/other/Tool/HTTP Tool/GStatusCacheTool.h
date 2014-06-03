//
//  GStatusCacheTool.h
//  数据存储
//
//  Created by AlfieL on 14-5-30.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GStatus;
@class GStatusesSid;
@interface GStatusCacheTool : NSObject
/**
 *  缓存一条新闻
 *
 *  @dict :需要缓存的新闻数据
 */
+ (void)addStatus:(NSDictionary *)status;

/**
 *  存入多条新闻
 *
 *  @dict :需要缓存的新闻数据
 */
+ (void)addStatuses:(NSArray *)statusArray;


/**
 *  从数据库读取数据 从param.sid_since 到 param.sid_end
 *
 *  @param param  参数模型
 *
 *  @return 取出的数据
 */
+ (NSArray *)readStatuesWithParam:(GStatusesSid *)param;


/**
 *  从数据库读取前 XXX 条的数据
 *
 *  @param  limit  限制的条数
 *
 *  @return 取出的数据
 */
+ (NSArray *)readStatuesWithLimit:(NSString *)limit;


// sid 是否在数据库中已经存在
+ (BOOL)isStatusAlreadyIn:(int)sid;


@end
