//
//  GStatusCacheTool.m
//  数据存储
//
//  Created by AlfieL on 14-5-30.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GStatusCacheTool.h"
#import "FMDB.h"
#import "GStatus.h"
#import "GStatusesSid.h"
#import "GHTTPTool.h"
@implementation GStatusCacheTool

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
        [db executeUpdate:@"create table if not exists t_status (id integer primary key autoincrement, sid integer, aid text, title_show text, hometext_show_short text, logo text, url_show text,time text, dict blob);"];
    }];
}

/**
 *  提供给外部的, 给数据库添加数据的方法
 *
 *  @param dictArray 要添加的数据
 */
+ (void)addStatuses:(NSArray *)dictArray
{
    for (NSDictionary *dict in dictArray) {
        [self addStatus:dict];
    }
}


/**
 *  内部的添加数据的方法
 *
 *  @param dict 要添加的数据
 */
+ (void)addStatus:(NSDictionary *)dict
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 1.获得需要存储的数据
//        int       sid  = [dict[@"sid"] intValue];
        NSString *sid  = dict[@"sid"];
        NSString *aid  = dict[@"aid"];
        NSString *logo = dict[@"logo"];
        NSString *title_show = dict[@"title_show"];
        NSString *hometext_show_short = dict[@"hometext_show_short"];
        NSString *url_show = dict[@"url_show"];
        NSString *time = dict[@"time"];
        NSData   *data = [NSKeyedArchiver archivedDataWithRootObject:dict];

        
        // 2.存储数据
//        [db executeUpdate:@"insert into t_status (aid, sid, dict) values(?,?,?)", aid,sid,data];
        
        [db executeUpdate:@"insert into t_status (sid, aid, title_show, hometext_show_short, logo, url_show,time, dict) values(?,?,?,?,?,?,?,?)", sid, aid, title_show, hometext_show_short, logo, url_show,time , data];
    }];
}


/**
 *  从数据库读取数据 从param.sid_since 到 param.sid_end
 *
 *  @param param  参数模型
 *
 *  @return 取出的数据
 */
+ (NSArray *)readStatuesWithParam:(GStatusesSid *)param
{
    
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@"select * from t_status where sid <= ? and sid => ?;" , param.sid_since , param.sid_end];
        
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dictArray addObject:dict];
        }
    }];
    
    // 3.返回数据
    return dictArray;
}

/**
 *  从数据库读取前 XXX 条的数据
 *
 *  @param  limit  限制的条数
 *
 *  @return 取出的数据
 */
+ (NSArray *)readStatuesWithLimit:(NSString *)limit
{
    
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@" select * from t_status LIMIT ?; " , limit];
        
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dictArray addObject:dict];
        }
    }];
    
    // 3.返回数据
    return dictArray;
}


/**
 *  isStatusAlreadyIn
 *
 *  @param sid 
 *
 *  @return  BOOL
 */
+ (BOOL)isStatusAlreadyIn:(int)sid
{
    
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;

        rs = [db executeQuery:@"select * from t_status where sid = ? ;" ,[NSString stringWithFormat:@"%d",sid]];
        
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
