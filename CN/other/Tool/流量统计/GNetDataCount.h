//
//  GNetDataCount.h
//  0000
//
//  Created by AlfieL on 14-6-14.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNetDataCount : NSObject
/**
 *  获取3G 流量
 *
 *  @return  int
 */
+ (int) getGprs3GFlowIOBytes;
/**
 *  获取所有 所有流量
 *
 *  @return  MBytes
 */
+ (long long int)getInterfaceMBytes;
/**
 *  获取流量
 *
 *  @param bytes 字节
 *
 *  @return 字符串
 */
+ (NSString *)bytesToAvaiUnit:(int)bytes;
@end
