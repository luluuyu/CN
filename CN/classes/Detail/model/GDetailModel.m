//
//  GDetail.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GDetailModel.h"
#import "TFHpple.h"
#import "AFNetworking.h"

@interface GDetailModel ()
@property (nonatomic, strong) GDetailModel *GDM;

@end

@implementation GDetailModel


- (void)setupContentWithURL:(NSString *)URL success:(void (^)(NSArray *arr))success
                    failure:(void (^)(NSError *error))failure
{
    
    // 用 AFN 获取网页内容
    AFHTTPRequestOperationManager * m = [AFHTTPRequestOperationManager manager];
    
    [m GET:[NSString stringWithFormat:@"http://www.cnbeta.com%@",URL] parameters:nil
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSString *HTMLString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
     // 解析正文 & 图像地址
      [self parseDetailCont:HTMLString];
     
     // 成功后回调
     success (self.detailContent);
     
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     failure(error);
     
 }];

    
    
}



#pragma cont 解析正文 & 图片
- (NSArray *)parseDetailCont:(NSString *)HTMLString{
    

    // 网页内容开始地方
    NSRange rang1=[HTMLString rangeOfString:@"<div class=\"content\">"];
//    NSRange rang1=[DetailContStr rangeOfString:@"<p>"];
    
    NSString *DetailContentString= [HTMLString substringFromIndex:rang1.location];
    
//    NSRange rang2=[DetailContStr2 rangeOfString:@"</div>"];\
    // 内容结束的地方
    NSRange rang2 = [DetailContentString rangeOfString:@"<div class=\"clear\"></div>"];
    DetailContentString = [DetailContentString substringToIndex:rang2.location];
    
    
    // 去除网页内容中的 <div class="content">
    rang2 = [DetailContentString rangeOfString:@"<div class=\"content\">"];
    DetailContentString = [DetailContentString substringFromIndex:rang2.length];
    

    
    // 转换成 array
    NSArray *arr = [DetailContentString componentsSeparatedByString:NSLocalizedString(@"</p>", nil)];
    
    NSMutableArray *contArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < arr.count; i++) {
        
        NSData *htmlData=[arr[i] dataUsingEncoding:/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*/NSUTF8StringEncoding];
        
        // 开始解析
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elementsCont  = [xpathParser searchWithXPathQuery:@"//p"];
        NSArray *elementsImage = [xpathParser searchWithXPathQuery:@"//img"];
        
        
        for (TFHppleElement *eImage in elementsImage) {
            
            NSDictionary *eleImage = [eImage attributes];
            NSString     *imageURL = [NSString stringWithString:[eleImage objectForKey:@"src"]];
            if (imageURL != nil) {
            
            NSString     *key      = [NSString stringWithFormat:@"imageURL"];
            NSDictionary *dict     = @{key: imageURL};
            [contArr addObject:dict];
            }
            
        }
        
        
        for (TFHppleElement *elementCont in elementsCont) {
            
            if ([elementCont content]!=nil) {
                
                NSString *str      = [NSString stringWithFormat:@"%@",[elementCont content]];
                NSString *key      = [NSString stringWithFormat:@"content"];
                NSDictionary *dict = @{key: str};
                [contArr addObject:dict];
             }
            
        }

    }
       
    return self.detailContent = contArr;
}





@end
