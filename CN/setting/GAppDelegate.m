//
//  GAppDelegate.m
//  CN
//
//  Created by AlfieL on 14-5-9.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GAppDelegate.h"
#import "GViewController.h"
#import "GNavController.h"
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "UMSocial.h"
@implementation GAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	// Override point for customization after application launch.
    
	GViewController *GV = [[GViewController alloc] init];
	GNavController *navigationController = [[GNavController alloc] initWithRootViewController:GV];
	self.window.rootViewController	= navigationController;
	[self.window makeKeyAndVisible];
	[Crashlytics startWithAPIKey:@"5e0b7bb211f1e833fb7f2c20c320cab13d19bab2"];
    [Flurry startSession:@"JZ5GZ3Z32DDCN4CMSRPR"];
//    [UMSocialData setAppKey:@"539c40b356240ba62f0aca62"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
