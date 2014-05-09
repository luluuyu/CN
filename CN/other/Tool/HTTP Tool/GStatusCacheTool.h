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
 *  缓存多条新闻
 *
 *  @dict :需要缓存的新闻数据
 */
+ (void)addStatuses:(NSArray *)statusArray;

+ (NSArray *)statuesWithParam:(GStatusesSid *)param;
@end
