//
//  GStastusCacheTool.m
//  CN
//
//  Created by AlfieL on 14-6-4.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GStastusDetailCacheTool.h"
#import "FMDB.h"
@implementation GStastusDetailCacheTool
static FMDatabaseQueue *_queue;
/**
 *  初始化
 */
+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_statusesDetail (id integer primary key autoincrement, sid integer , sta text , dict blob);"];
        NSLog(@"%@",[NSBundle mainBundle]);
    }];
}

+ (void)addStatus:(NSDictionary *)status
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 1.获得需要存储的数据

        NSString *sid  = status[@"sid"];
        NSArray  *sta  = status[@"sta"];
        NSData   *data = [NSKeyedArchiver archivedDataWithRootObject:status];
        
        
        // 2.存储数据
        //        [db executeUpdate:@"insert into t_status (aid, sid, dict) values(?,?,?)", aid,sid,data];
        
        [db executeUpdate:@"insert into t_statusesDetail (sid, sta, dict) values(?,?,?)", sid, sta, data];
    }];
}


+ (NSArray *)readStatuesWithSid:(int)sid;

{
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    __block NSDictionary *dictArr = [[NSDictionary alloc]init];
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;

        rs = [db executeQuery:@"select * from t_statusesDetail where sid = ? ;" ,[NSString stringWithFormat:@"%d",sid] ];
        
        while (rs.next) {
           NSData *data = [rs dataForColumn:@"dict"];
            dictArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
             NSLog(@"%@",dictArr);
            [dictArray addObject: dictArr[@"sta"]];
        }
    }];
    
       // 3.处理返回的数据返回数据
    
    return  [dictArray lastObject];
}


// sid 是否在数据库中已经存在
+ (BOOL)isStatusAlreadyIn:(int)sid
{
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@"select * from t_statusesDetail where sid = ? ;" ,[NSString stringWithFormat:@"%d",sid]];
        
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dictArray addObject:dict];
        }
    }];
    
    if (dictArray.count == 1) {
        return YES;
    }else {
        return NO;
    }
}

@end
