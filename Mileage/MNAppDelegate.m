//
//  MNAppDelegate.m
//  Mileage
//
//  Created by mattneary on 2/27/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNAppDelegate.h"

@implementation MNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithWhite:0.5 alpha:1], UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithWhite:0.85 alpha:1], UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor, nil]
                                             forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"instagram.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    self.mntvc.shouldCompareDistance = NO;
    [self.mntvc setResumeButton];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.mntvc.shouldCompareDistance = NO;
    [self.mntvc setResumeButton];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Put FVC in the same state as startup, so initial approximations are not counted towards travel.
    
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
