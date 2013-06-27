//
//  MNInsertView.m
//  Mileage
//
//  Created by mattneary on 3/12/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNInsertView.h"
#import "MNTrackingViewController.h"
#import "MNNavigationController.h"
#import "MNHistoryView.h"

@implementation MNInsertView
-(void)viewDidLoad {
//    self.edgesForExtendedLayout = UIExtendedEdgeNone;
    MNTrackingViewController *mntvc = [self.storyboard instantiateViewControllerWithIdentifier:@"track"];
    mntvc.delegate = self;
    [self pushViewController:mntvc animated:YES];
}
- (void)dismiss {
    [self.delegate goHome];
}
@end
