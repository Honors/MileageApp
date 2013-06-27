//
//  MNTabBar.m
//  Mileage
//
//  Created by mattneary on 3/10/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNTabBar.h"
#import "MNTrackingViewController.h"
#import "MNNavigationController.h"
#import "MNInsertView.h"
#import "MNHistoryView.h"

@implementation MNTabBar
- (void)viewDidLoad {
//    self.edgesForExtendedLayout = UIExtendedEdgeNone;
    NSMutableArray *views = [NSMutableArray arrayWithArray:self.viewControllers];
    views[1] = [self.storyboard instantiateViewControllerWithIdentifier:@"nav"];
    self.viewControllers = views;
    ((UITabBarItem *)self.tabBar.items[1]).image = [UIImage imageNamed:@"track.png"];
    ((UITabBarItem *)self.tabBar.items[1]).title = @"Track";
}
- (void)goHome {
    [self dismissViewControllerAnimated:YES completion:nil];
    [((MNHistoryView *)self.viewControllers[0]) reload];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {    
    if( [item.title isEqualToString:@"Track"] ) {
        MNInsertView *mniv = [self.storyboard instantiateViewControllerWithIdentifier:@"metanav"];
        mniv.delegate = self;
        [self presentViewController:mniv animated:YES completion:^(void) {
            self.selectedViewController = self.viewControllers[0];
        }];
    }
}
@end
