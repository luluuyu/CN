//
//  GSettingVC.m
//  CN
//
//  Created by AlfieL on 14-6-15.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GSettingVC.h"
#import "GNetDataCount.h"
#import "GStatusCacheTool.h"
#import "GRightsReserved.h"
#import <MessageUI/MessageUI.h>
@interface GSettingVC () <UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *NetDataContLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *StatusCountLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *RightsReservedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *suggestionCell;
@property (strong , nonatomic)UIWebView *webView;


@end

@implementation GSettingVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.NetDataContLabel.detailTextLabel.text = [NSString stringWithFormat:@"%lld MB",[GNetDataCount getInterfaceMBytes] / 1024 /1024];
    self.StatusCountLabel.detailTextLabel.text = [GStatusCacheTool getSidCount];
    
    // 监听 cell 的点击
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightCellBeCicked)];
    [self.RightsReservedCell addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(suggestionCellBeCicked)];
    [self.suggestionCell addGestureRecognizer:tap2];
    
}

- (void)suggestionCellBeCicked
{
   [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"mailto://iosDev2012@163.com"]];

}

- (void)rightCellBeCicked {
    self.RightsReservedCell.selected = YES;
    GRightsReserved *grv = [[GRightsReserved alloc]init];
    grv.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:grv animated:YES];
    self.RightsReservedCell.selected = NO;
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{

    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
