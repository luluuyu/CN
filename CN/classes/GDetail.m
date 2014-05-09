//
//  GDetail.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GDetail.h"
#import "TFHpple.h"

@implementation GDetail



#pragma 解析title
-(NSString *)parseTitle:(NSString *)urlString{
    
    NSString *title=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*/error:nil];
    
    
    NSRange range=[title rangeOfString:@"<h2 id=\"news_title\">"];

    NSMutableString *needTidyString=[NSMutableString stringWithString:[title substringFromIndex:range.location+range.length]];
   
    //提取标题 - L
    NSRange rang2=[needTidyString rangeOfString:@"</h2>"];
  
    NSMutableString *html2=[NSMutableString stringWithString:[needTidyString substringToIndex:rang2.location]];
    
    /*
    NSMutableArray *titleArray = [[NSMutableArray alloc]init];

    titleArray=[[NSMutableArray alloc]init];
    
    [titleArray addObject:html2];
    
    NSMutableString *str = [NSMutableString string];
    for (NSString *str1 in titleArray) {
        [str appendString:str1];
    }*/
    _titleStr = html2;
    return _titleStr;
    
    
}

#pragma 解析subTitle
-(NSString *)parseSubTitle:(NSString *)htmlString
{
    
    NSString *subTitle=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*/error:nil];
    
    
    NSRange range=[subTitle rangeOfString:@"<div class=\"introduction\">"];
    
    NSMutableString *needTidyString=[NSMutableString stringWithString:[subTitle substringFromIndex:range.location+range.length]];

    //提取标题 - L
    NSRange rang2=[needTidyString rangeOfString:@"</p>"];
    
    NSMutableString *html2=[NSMutableString stringWithString:[needTidyString substringToIndex:rang2.location]];
    
    NSMutableArray *subTitleArray = [[NSMutableArray alloc]init];
    subTitleArray=[[NSMutableArray alloc]init];
    
    [subTitleArray addObject:html2];
    
    NSMutableString *strM = [NSMutableString string];
    for (NSString *str in subTitleArray) {
        [strM appendString:str];
    }
    _hometext_show_short = strM;
    return _hometext_show_short;
    

}

#pragma 解析image地址
-(NSMutableArray *)parseImageURL:(NSString *)htmlString;{
    
    
    //获得 URL 的数据
    NSString *imageStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding error:nil];
    
    
    NSRange rang1=[imageStr rangeOfString:@"<div class=\"content\">"];
    NSMutableString *imageStr2=[[NSMutableString alloc]initWithString:[imageStr substringFromIndex:rang1.location+rang1.length]];
    
    
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
-(NSString *)parseDetailCont:(NSString *)htmlString{
    
    //获得 URL
    NSString *DetailContStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding error:nil];
    //网页内容开始地方
    NSRange rang1=[DetailContStr rangeOfString:@"<div class=\"content\">"];
//    NSRange rang1=[DetailContStr rangeOfString:@"<p>"];
    
    NSMutableString *DetailContStr2=[[NSMutableString alloc]initWithString:[DetailContStr substringFromIndex:rang1.location]];
    
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
    _contStr = str;
    NSLog(@"%@",str);

    
    return _contStr;
}

#pragma cont 解析正文
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
    
    self.subContArray = contArray;
    
    
    return _subContArray;
}

@end
