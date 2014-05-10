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

+ (void)addStatuses:(NSArray *)dictArray
{
    for (NSDictionary *dict in dictArray) {
        [self addStatus:dict];
    }
}

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
 *  读取数据库的最新60条数据
 *
 *  @param param  当前时间获取到的最大的 sid
 *
 *  @return 缓存数据
 */
+ (NSArray *)statuesWithParam:(GStatusesSid *)param
{
    
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        
        
        NSString *sid_miniStr = [NSString stringWithFormat:@"%d",param.sid_end];
        rs = [db executeQuery:@"select * from t_status where sid > ?;" , sid_miniStr];
        
        
        
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dictArray addObject:dict];
        }
    }];
    
    // 3.返回数据
    return dictArray;
}


//+ (void)initialize
//{
//    // 0.获得沙盒中的数据库文件名
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
//    
//    // 1.创建队列
//    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
//    
//    // 2.创表
//    [_queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"create table if not exists t_status (id integer primary key autoincrement, access_token text, idstr text, status blob);"];
//    }];
//}
//
//+ (void)addStatuses:(NSArray *)statusArray
//{
//    for (GStatus *status in statusArray) {
//        [self addStatus:status];
//    }
//}
//
//+ (void)addStatus:(GStatus *)status
//{
//    [_queue inDatabase:^(FMDatabase *db) {
//        // 1.获得需要存储的数据
//        //        NSString *accessToken = [IWAccountTool account].access_token;
//        //        NSString *idstr = status.idstr;
//        NSString *sid = status.sid;
//        NSString *aid = status.aid;
//        
//        NSString *title_show = status.title_show;
//        NSString *hometext_show_short = status.hometext_show_short;
//        
//        NSString *logo = status.logo;
//        NSString *url_show = status.url_show;
//        //        NSString *counter = status.counter;
//        //        NSString *score = status.score;
//        //        NSString *ratings = status.ratings;
//        //        NSString *score_story = status.score_story;
//        //        NSString *ratings_story = status.ratings_story;
//        //        NSString *rate_sum = status.rate_sum;
//        //        NSString *dig = status.dig;
//        //        NSString *time = status.time;
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
//        
//        // 2.存储数据
//        [db executeUpdate:@"insert into t_status (sid, aid, title_show, hometext_show_short, logo, url_show, status) values(?, ? , ?)", sid, aid, title_show, hometext_show_short, logo, url_show, data];
//    }];
//}

@end
