//
//  GDetail.m
//  cnBeta阅读器
//
//  Created by AlfieL on 14-4-28.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GHomeParse.h"
#import "TFHpple.h"

@implementation GHomeParse



#pragma 解析title
-(NSString *)parseTitle:(NSString *)Xml{
    
    if (Xml.length > 1000) {
        
    NSString *tempstr = @"<a target=\"_blank\" href=\"";
    NSRange   rang1=[Xml rangeOfString:tempstr];
    NSString *tempTitle1=[Xml substringFromIndex:rang1.location];
    
    //小段内容结束的地方
    NSString *temptag = @"<div class=\"tools\">";
    NSRange   rang2 = [tempTitle1 rangeOfString:temptag];
    NSString *tempTitle2 = [tempTitle1 substringToIndex:rang2.location + temptag.length];
    
    
    //取出网址
    NSRange   linkRange = [tempTitle2 rangeOfString:@"\">"];
    NSString *link      = [tempTitle2 substringWithRange:NSMakeRange(tempstr.length, linkRange.location - tempstr.length)];
    self.url_show = link;
    
    
    //取出标题
    NSRange titleRange1 = [tempTitle2 rangeOfString:@".htm\">"];
    NSString *title     = [tempTitle2 substringFromIndex:titleRange1.location + 6];
    NSRange titleRange2 = [title rangeOfString:@"</a>"];
    title               = [title substringToIndex:titleRange2.location];
    self.title_show = title;
    
    
    //取出子标题
    NSString *tempsubTitel = @"<div class=\"newsinfo fl\">\n                                    <p>";
    NSRange subTitelRange  = [tempTitle2 rangeOfString:tempsubTitel];
    NSString *subTitle     = [tempTitle2 substringFromIndex:subTitelRange.location + tempsubTitel.length];
    NSRange subTitelRange2 = [subTitle rangeOfString:@"</p>"];
    subTitle               = [subTitle substringToIndex:subTitelRange2.location];
    self.hometext_show_short       = subTitle;
    
    NSString *tempStr2 = @"<div class=\"clear\"></div>";
    NSRange rang4 = [Xml rangeOfString:tempStr2];
    NSString *excessXml = [Xml substringFromIndex:rang4.location + tempStr2.length];
    
    

    
    
    return excessXml;
    }else {
    return Xml;
    }
    
}

#pragma 解析subTitle
-(NSString *)parseSubTitle:(NSString *)subTitle
{
    
//    NSString *subTitle=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding/*CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)*/error:nil];
    
    
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
-(NSMutableArray *)parseImageURL:(NSString *)imageStr{
     
    
    //获得 URL 的数据
    
//    NSString *imageStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding error:nil];
    
    
    NSRange rang1=[imageStr rangeOfString:@"<div class=\"items_area\">"];
    NSMutableString *imageStr2=[[NSMutableString alloc]initWithString:[imageStr substringFromIndex:rang1.location+rang1.length]];
    
    
    NSRange rang2=[imageStr2 rangeOfString:@"<div class=\"loading\" style=\"text-align:center;display:none\">"];
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
-(NSString *)parseDetailCont:(NSString *)DetailContStr{
    
    //获得 URL 
//    NSString *DetailContStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding error:nil];
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
   

    
    return _contStr;
}

#pragma cont 解析正文
-(NSArray *)parseAllSubCont:(NSString *)DetailContStr{
    
    //获得 URL
//    NSString *DetailContStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:htmlString] encoding:NSUTF8StringEncoding error:nil];
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
