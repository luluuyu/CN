//
//  GHTTPTool.m
//  数据存储
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GHTTPTool.h"
#import "GViewController.h"
#import "GStatus.h"
#import "MJExtension.h"
#import "FMDB.h"
#import "GStatusCacheTool.h"
#import "AFNetworking.h"
#import "GStatusesSid.h"

@interface GHTTPTool ()

@end

@implementation GHTTPTool


+ (void)getNewStatusesFromNetwork:(int)sid success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure
{
    [[[GHTTPTool alloc]init] getNewStatusesFromNetwork:sid success:^(NSArray *newData) {
        if (success) {
            success(newData);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(failure);
        }
    }];
}

+ (void)getOldStatusesFromNetwork:(GStatusesSid *)param success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure
{
    [[[GHTTPTool alloc]init] getOldStatusesFromNetwork:param success:^(NSArray *newData) {
        if (success) {
            success(newData);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(failure);
        }
    }];
}

- (void)getOldStatusesFromNetwork:(GStatusesSid *)param success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure {
    
    //设置网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 先取出数据中最大和最小的 sid
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *max_sid        = [defaults objectForKey:@"maxSid"];
//    NSString *mini_sid       = [defaults objectForKey:@"miniSid"];
    
    // 
    
    NSURL *url = [NSURL URLWithString:[self getURLStr:param.page]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *headerFields = @{
                                   @"Host"      :  @"www.cnbeta.com",
                                   @"Referer"   :  @"http://www.cnbeta.com",
                                   @"User-Agent":  @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10",
                                   @"Connection":  @"keep-alive",
                                   
                                   };
    
    [request setAllHTTPHeaderFields:headerFields];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 60];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    
    
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        
        if (!connectionError) {
            
            NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSRange range1 = [strReturn rangeOfString:@"[{\"sid\":\""];
            NSRange range2 = [strReturn rangeOfString:@",\"pager\":\""];
            
            
            strReturn = [strReturn substringFromIndex:range1.location ];
            strReturn = [strReturn substringToIndex:range2.location - range1.location];
            
            
            
            NSArray *arr = [strReturn componentsSeparatedByString:NSLocalizedString(@"},", nil)];
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                
                NSString *status = [self replaceUnicode:arr[i]];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                
                [dict setValue:[self parse:@"sid" arr:status]        forKey:@"sid"];
                [dict setValue:[self parse:@"aid" arr:status]        forKey:@"aid"];
                [dict setValue:[self parse:@"title_show" arr:status] forKey:@"title_show"];
                [dict setValue:[self parse:@"logo" arr:status]       forKey:@"logo"];
                [dict setValue:[self parse:@"url_show" arr:status]   forKey:@"url_show"];
                [dict setValue:[self parse:@"counter" arr:status]    forKey:@"counter"];
                [dict setValue:[self parse:@"score" arr:status]      forKey:@"score"];
                [dict setValue:[self parse:@"dig" arr:status]        forKey:@"dig"];
                [dict setValue:[self parseTime:status]               forKey:@"time"];
                [dict setValue:[self parse:@"ratings_story" arr:status]       forKey:@"ratings_story"];
                [dict setValue:[self parse:@"hometext_show_short" arr:status] forKey:@"hometext_show_short"];
                
                
                [ma addObject:dict];
                
                // 当前数据的sid
                int currentSid = [dict[@"sid"] intValue];
                
                // 当前数据的sid sid 大于 本地数据库存储的最大 sid
                if (![GStatusCacheTool isSidAlreadyIn:currentSid]) {
                    [GStatusCacheTool addStatus:dict];
                    // 判断是否需要写入本次获取到的最小 sid
                    if (i == (arr.count - 1) )  {
                        [defaults setObject:[NSString stringWithFormat:@"%d",currentSid] forKey:@"miniSid"];
                        [defaults synchronize];
                    }
                }
            };
            
            // 转成GStatus模型
            NSArray *statusArray = [GStatus objectArrayWithKeyValuesArray:ma];
            
            // 从数据库中取出数据
           
            success (statusArray);
            
        }else {
            failure (failure);
            
        }
        
    }];
    
    
    
}

- (void)getNewStatusesFromNetwork:(int)sid success:(void (^)(NSArray *newData))success failure:(void (^)(NSError *error))failure {
    
    //设置网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *url = [NSURL URLWithString:[self getURLStr:1]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *headerFields = @{
                                   @"Host"      :  @"www.cnbeta.com",
                                   @"Referer"   :  @"http://www.cnbeta.com",
                                   @"User-Agent":  @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10",
                                   @"Connection":  @"keep-alive",
                                   
                                   };
    
    [request setAllHTTPHeaderFields:headerFields];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 60];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        

        
        if (response) {
            
            NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSRange range1 = [strReturn rangeOfString:@"[{\"sid\":\""];
            NSRange range2 = [strReturn rangeOfString:@",\"pager\":\""];
            
            
            strReturn = [strReturn substringFromIndex:range1.location ];
            strReturn = [strReturn substringToIndex:range2.location - range1.location];
            
            
            
            NSArray *arr = [strReturn componentsSeparatedByString:NSLocalizedString(@"},", nil)];
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                
                
                NSString *status = [self replaceUnicode:arr[i]];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                
                [dict setValue:[self parse:@"sid" arr:status]        forKey:@"sid"];
                [dict setValue:[self parse:@"aid" arr:status]        forKey:@"aid"];
                [dict setValue:[self parse:@"title_show" arr:status] forKey:@"title_show"];
                [dict setValue:[self parse:@"logo" arr:status]       forKey:@"logo"];
                [dict setValue:[self parse:@"url_show" arr:status]   forKey:@"url_show"];
                [dict setValue:[self parse:@"counter" arr:status]    forKey:@"counter"];
                [dict setValue:[self parse:@"score" arr:status]      forKey:@"score"];
                [dict setValue:[self parse:@"dig" arr:status]        forKey:@"dig"];
                [dict setValue:[self parseTime:status]               forKey:@"time"];
                [dict setValue:[self parse:@"ratings_story" arr:status]       forKey:@"ratings_story"];
                [dict setValue:[self parse:@"hometext_show_short" arr:status] forKey:@"hometext_show_short"];
                
                
                [ma addObject:dict];
                
                //当前数据的sid
                int currentSid = [dict[@"sid"] intValue];
                
                //
                if (![GStatusCacheTool isSidAlreadyIn:currentSid]) {
                    [GStatusCacheTool addStatus:dict];
                }
                
                
            };
            
            // 转成GStatus模型
            NSArray *statusArray = [GStatus objectArrayWithKeyValuesArray:ma];
            
            //写入本次获取到的最大sid
            GStatus *statusMax = statusArray[0];
            NSString *maxSid = statusMax.sid;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:maxSid forKey:@"maxSid"];
            [defaults synchronize];
            
            //如果本机已经存储了一次 miniSid 先从本机取出, 如果没有进行创建
            GStatus *statusMini = statusArray[arr.count - 1];
            
            NSString *miniSid = [defaults objectForKey:@"miniSid"];
            
            if(miniSid == nil){
                // 第一次写入
                [defaults setObject:statusMini.sid forKey:@"miniSid"];
                
            }
            
            if ([miniSid intValue] > [statusMini.sid intValue]){
                // 更新最小 sid
                [defaults setObject:statusMini.sid forKey:@"miniSid"];
                [defaults synchronize];
            }
            
            // 网络请求访问成功返回数据
            success (statusArray);
            
        }else {
            failure (failure);
            
        }
        
    }];
    
    
    
}


- (NSString *)getURLStr:(int)page
{
    
    // 从1970到现在的时间秒
    NSTimeInterval date = [[NSDate new] timeIntervalSince1970];
    //换算成0.1毫秒
    long long time= date * 10000 ;
    //转换成字符串
    NSString *sm = [NSString stringWithFormat:@"%lld",time];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cnbeta.com/more.htm?jsoncallback=jQuery18009503329019265727_1371789998227&type=all&page=%d&_=%@",page,sm];
    
    return urlStr;
}


- (NSString *)parse: (NSString *)str arr:(NSString *)arr

{
    NSRange   Beg   = [arr rangeOfString:[NSString stringWithFormat:@"\"%@\":\"",str]];
    NSString *sid   = [arr substringFromIndex:Beg.location + Beg.length ];
    
    NSRange   End   = [sid rangeOfString:@"\",\""];
    NSString *strR = [sid substringToIndex:End.location];
    return strR;
}


/**
 *  解析时间
 */
- (NSString *)parseTime:(NSString *)arr

{
    NSRange   Beg   = [arr rangeOfString:[NSString stringWithFormat:@"\"time\":\""]];
    NSString *sid   = [arr substringFromIndex:Beg.location + Beg.length ];
    
    NSRange   End   = [sid rangeOfString:@"\""];
    NSString *strR = [sid substringToIndex:End.location];
    return strR;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    
    
    NSString *tempStr1  = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2  = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3  = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData   *tempData  = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];


    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


@end
