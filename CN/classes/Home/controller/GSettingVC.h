//
//  GSettingVC.h
//  CN
//
//  Created by AlfieL on 14-6-15.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sugesstionCellDidClickedDelegate <NSObject>
@optional
- (void)sugesstionCellDidClickedDelegate;

@end

@interface GSettingVC : UIViewController
@property (nonatomic, weak) id <sugesstionCellDidClickedDelegate> delegate;
@end
