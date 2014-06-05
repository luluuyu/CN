//
//  GStastusCacheTool.h
//  CN
//
//  Created by AlfieL on 14-6-4.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GStastusDetailCacheTool : NSObject

/**
 *  缓存一条新闻
 *
 *  @dict :需要缓存的新闻数据
 */
+ (void)addStatus:(NSDictionary *)status;



/**
 *  从数据库读取 sid 为 sid 的数据
 *
 */
+ (NSArray *)readStatuesWithSid:(int)sid;




// sid 是否在数据库中已经存在
+ (BOOL)isStatusAlreadyIn:(int)sid;


@end
