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

@interface GHTTPTool ()
@property (nonatomic,copy)NSArray * statusArray;
@end

@implementation GHTTPTool

//+ (NSArray *)getStatusesFrom:(int)sid
//{
//    if (sid ) {
//        <#statements#>
//    }
//    
//    return <#expression#>;
//}
+ (void)getStatusesFromNetwork:(int)sid
{
    [[[GHTTPTool alloc]init] getStatusesFromNetwork:sid];
}

- (void)getStatusesFromNetwork:(int)sid{
    
    
    NSURL *url = [NSURL URLWithString:[self test3]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *headerFields = @{
                                   @"Host":        @"www.cnbeta.com",
                                   @"Referer":     @"http://www.cnbeta.com",
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
            strReturn = [self replaceUnicode:strReturn];
            NSRange range1 = [strReturn rangeOfString:@"jQuery18009503329019265727_1371789998227({\"status\":\"success\",\"result\":{\"list\":"];
            NSRange range2 = [strReturn rangeOfString:@",\"pager\":\"\",\"auto\":1,\"type\":\"all\"}})"];
            
            
            strReturn = [strReturn substringFromIndex:range1.length ];
            strReturn = [strReturn substringToIndex:strReturn.length - range2.length];
            
            
            
            NSArray *arr = [strReturn componentsSeparatedByString:NSLocalizedString(@"},", nil)];
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < 60; i++) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                
                [dict setValue:[self parse:@"sid" arr:arr[i]] forKey:@"sid"];
                [dict setValue:[self parse:@"aid" arr:arr[i]] forKey:@"aid"];
                [dict setValue:[self parse:@"title_show" arr:arr[i]] forKey:@"title_show"];
                [dict setValue:[self parse:@"hometext_show_short" arr:arr[i]]    forKey:@"hometext_show_short"];
                [dict setValue:[self parse:@"logo" arr:arr[i]]    forKey:@"logo"];
                [dict setValue:[self parse:@"url_show" arr:arr[i]]    forKey:@"url_show"];
                [dict setValue:[self parse:@"counter" arr:arr[i]]    forKey:@"counter"];
                [dict setValue:[self parse:@"score" arr:arr[i]]    forKey:@"score"];
                [dict setValue:[self parse:@"ratings_story" arr:arr[i]]    forKey:@"ratings_story"];
                [dict setValue:[self parse:@"dig" arr:arr[i]]    forKey:@"dig"];
                [dict setObject:[self parseTime:arr[i]] forKey:@"time"];
                
                
                [ma addObject:dict];
                
                
                //取出最大sid
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *sidMax = [defaults stringForKey:@"maxSid"];
                unsigned long sidMaxInt = [sidMax intValue];
                
                //当前数据的sid
                unsigned long currentSid = [dict[@"sid"] intValue];
                
                //如果网络数据的 sid 大于 本地数据库存储的最大 sid
                if (currentSid > sid) {
                    [GStatusCacheTool addStatus:dict];
                }
                
                
            };
            
            NSArray *statusArray = [GStatus objectArrayWithKeyValuesArray:ma];
            
            self.statusArray = statusArray;
            NSString *maxSid = [[NSString alloc]init];
            GStatus *status = statusArray[0];
            maxSid = status.sid;
            
            //写入本次获取到的最大sid
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:maxSid forKey:@"maxSid"];
            
            
        }else {
            NSLog(@"%@",connectionError);
            
        }
        
    }];
    
    
}


- (NSString *)test3
{
    
    // 从1970到现在的时间秒
    NSTimeInterval date = [[NSDate new] timeIntervalSince1970];
    //换算成0.1毫秒
    long long time= date * 10000 ;
    //转换成字符串
    NSString *sm = [NSString stringWithFormat:@"%lld",time];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.cnbeta.com/more.htm?jsoncallback=jQuery18009503329019265727_1371789998227&type=all&page=1&_=%@",sm];
    
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

- (NSString *)parseTime:(NSString *)arr

{
    NSRange   Beg   = [arr rangeOfString:[NSString stringWithFormat:@"\"time\":\""]];
    NSString *sid   = [arr substringFromIndex:Beg.location + Beg.length ];
    
    NSRange   End   = [sid rangeOfString:@"\""];
    NSString *strR = [sid substringToIndex:End.location];
    return strR;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];

    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


@end
