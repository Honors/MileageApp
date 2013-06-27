//
//  MNAppDelegate.h
//  Mileage
//
//  Created by mattneary on 2/27/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNTrackingViewController.h"

@interface MNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MNTrackingViewController *mntvc;

@end
