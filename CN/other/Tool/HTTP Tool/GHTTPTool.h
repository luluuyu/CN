//
//  GHTTPTool.h
//  数据存储
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GStatusesSid ;
@interface GHTTPTool : NSObject
/**
 *  发送一个网络请求
 *
 *  @param sid        目前存储的最大 sid
 *  @param success    网路请求成功后的回调
 *  @param failure    网络请求失败后的回调
 */
+ (void)getNewStatusesFromNetwork:(int)sid success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure;

- (void)getNewStatusesFromNetwork:(int)sid success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure;

+ (void)getOldStatusesFromNetwork:(GStatusesSid *)param success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure;

- (void)getOldStatusesFromNetwork:(GStatusesSid *)param success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure;
@end
