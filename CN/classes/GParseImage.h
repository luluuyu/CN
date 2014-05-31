//
//  GParseImage.h
//  cnBeta阅读器
//
//  Created by AlfieL on 14-5-2.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GParseImage : UIImageView

{
    NSURLConnection *connection;
    NSMutableData *loadData;
}

//图片对应的缓存在沙河中的路径
@property (nonatomic, retain) NSString *fileName;
//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;
//请求网络图片的URL
@property (nonatomic, retain) NSString *imageURL;

@end

