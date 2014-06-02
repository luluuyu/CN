//
//  GGStatusesSid.h
//  数据存储
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GStatusesSid : NSObject

@property (nonatomic, copy  )   NSString  *sid_max;       //当前存储的最大的 sid
@property (nonatomic, copy  )   NSString  *sid_since;     //从哪个 sid 开始
@property (nonatomic, copy  )   NSString  *sid_end;       //到哪个 sid 结束
@property (nonatomic, assign)   int        page;          //第几页


+ (int)setSidForint:(NSString *)sid;

@end
