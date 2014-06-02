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

@implementation GDetailModel





- (void)setupContentWithURL:(NSString *)URL success:(void (^)(NSString *str))success
                    failure:(void (^)(NSError *error))failure
{
    // 用 AFN 获取网页内容
    AFHTTPRequestOperationManager * m = [AFHTTPRequestOperationManager manager];
    
    [m GET:[NSString stringWithFormat:@"http://www.cnbeta.com%@",URL] parameters:nil
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSString *HTMLString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
     // 解析正文
     self.detailContent  = [self parseDetailCont:HTMLString];
//     NSArray *imgeURL    = [self parseImageURL:HTMLString];
     // 成功后回调
     success (self.detailContent);
     
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
 }];
    
    
    
    
}




#pragma 解析image地址
-(NSMutableArray *)parseImageURL:(NSString *)HTMLString;{
    
    
    //获得 URL 的数据
    
    
    
    NSRange rang1=[HTMLString rangeOfString:@"<div class=\"content\">"];
    NSMutableString *imageStr2=[[NSMutableString alloc]initWithString:[HTMLString substringFromIndex:rang1.location+rang1.length]];
    
    
    NSRange rang2=[imageStr2 rangeOfString:@"<div class=\"clear\"></div>"];
    NSMutableString *imageStr3=[[NSMutableString alloc]initWithString:[imageStr2 substringToIndex:rang2.location]];
    
    
    
    NSData *dataTitle=[imageStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *xpathParser=[[TFHpple alloc]initWithHTMLData:dataTitle];
    
    NSArray *elements=[xpathParser searchWithXPathQuery:@"//img"];
    
    
    
    _imageArray=[[NSMutableArray alloc]init];
    
    
    
    
    for (TFHppleElement *element in elements) {
        
        NSDictionary *elementContent =[element attributes];
        [_imageArray addObject:[elementContent objectForKey:@"src"]];
    }
   
    return _imageArray;
    
}



#pragma cont 解析正文
- (NSString *)parseDetailCont:(NSString *)HTMLString{
    

    //网页内容开始地方
    NSRange rang1=[HTMLString rangeOfString:@"<div class=\"content\">"];
//    NSRange rang1=[DetailContStr rangeOfString:@"<p>"];
    
    NSMutableString *DetailContStr2=[[NSMutableString alloc]initWithString:[HTMLString substringFromIndex:rang1.location]];
    
//    NSRange rang2=[DetailContStr2 rangeOfString:@"</div>"];\
    //内容结束的地方
    NSRange rang2=[DetailContStr2 rangeOfString:@"<div class=\"clear\"></div>"];
    NSMutableString *DetailContStr3=[[NSMutableString alloc]initWithString:[DetailContStr2 substringToIndex:rang2.location]];
    
    
    NSData *htmlData=[DetailContStr3 dataUsingEncoding:/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*/NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"];
    
    NSMutableArray *contArray = [[NSMutableArray alloc]init];
    
    if (contArray== nil) {
        contArray=[[NSMutableArray alloc]init];
    }
    
    for (TFHppleElement *element in elements) {
        
        if ([element content]!=nil) {
           [contArray addObject:[element content]];
        }
    }

    NSMutableString *str = [NSMutableString string];
    for (NSString *str1 in contArray) {
        [str appendFormat:@"     %@ \n\n" ,str1];
    }
    return str;
}





#pragma cont 解析正文 暂时不用了
/*
-(NSArray *)parseAllSubCont:(NSString *)htmlString{
    
    //获得 URL
    NSString *DetailContStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding error:nil];
    //网页内容开始地方
    NSRange rang1=[DetailContStr rangeOfString:@"<div class=\"items_area\">"];
    //    NSRange rang1=[DetailContStr rangeOfString:@"<p>"];
    
    NSMutableString *DetailContStr2=[[NSMutableString alloc]initWithString:[DetailContStr substringFromIndex:rang1.location]];
    
    //    NSRange rang2=[DetailContStr2 rangeOfString:@"</div>"];\
    //内容结束的地方
    NSRange rang2=[DetailContStr2 rangeOfString:@"<div class=\"loading\""];
    NSMutableString *DetailContStr3=[[NSMutableString alloc]initWithString:[DetailContStr2 substringToIndex:rang2.location]];
    
    
    NSData *htmlData=[DetailContStr3 dataUsingEncoding:/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*\/NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"];
    
    NSMutableArray *contArray = [[NSMutableArray alloc]init];
    
    if (contArray== nil) {
        contArray=[[NSMutableArray alloc]init];
    }
    
    for (TFHppleElement *element in elements) {
        
        if ([element content]!=nil) {
            [contArray addObject:[element content]];
        }
    }
    
    self.subContArray = contArray;
    
    
    return _subContArray;
}
*/
#pragma 解析title    暂时不用了 , 直接从 Home 控制器传过来控制器
/*
 -(NSString *)parseTitle:(NSString *)XMLString{
 
 NSString *title = XMLString;
 
 
 NSRange range=[title rangeOfString:@"<h2 id=\"news_title\">"];
 
 NSMutableString *needTidyString=[NSMutableString stringWithString:[title substringFromIndex:range.location+range.length]];
 
 //提取标题 - L
 NSRange rang2=[needTidyString rangeOfString:@"</h2>"];
 
 NSMutableString *html2=[NSMutableString stringWithString:[needTidyString substringToIndex:rang2.location]];
 
 
 //    NSMutableArray *titleArray = [[NSMutableArray alloc]init];
 //
 //    titleArray=[[NSMutableArray alloc]init];
 //
 //    [titleArray addObject:html2];
 //
 //    NSMutableString *str = [NSMutableString string];
 //    for (NSString *str1 in titleArray) {
 //        [str appendString:str1];
 //    }
 
 _titleStr = html2;
 return _titleStr;
 }*/
#pragma 解析subTitle 暂时不用了 , 直接从 Home 控制器传过来子标题
/*
 -(NSString *)parseSubTitle:(NSString *)htmlString
 {
 //
 //    NSString *subTitle=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*\/error:nil];
 //
 //
 //    NSRange range=[subTitle rangeOfString:@"<div class=\"introduction\">"];
 //
 //    NSMutableString *needTidyString=[NSMutableString stringWithString:[subTitle substringFromIndex:range.location+range.length]];
 //
 //    //提取标题 - L
 //    NSRange rang2=[needTidyString rangeOfString:@"</p>"];
 //
 //    NSMutableString *html2=[NSMutableString stringWithString:[needTidyString substringToIndex:rang2.location]];
 //
 //    NSMutableArray *subTitleArray = [[NSMutableArray alloc]init];
 //    subTitleArray=[[NSMutableArray alloc]init];
 //
 //    [subTitleArray addObject:html2];
 //
 //    NSMutableString *strM = [NSMutableString string];
 //    for (NSString *str in subTitleArray) {
 //        [strM appendString:str];
 //    }
 //    _hometext_show_short = strM;
 //    return _hometext_show_short;
 //    
 //
 } */
@end
