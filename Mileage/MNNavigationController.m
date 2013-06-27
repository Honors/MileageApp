//
//  MNNavigationController.m
//  Mileage
//
//  Created by mattneary on 3/10/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNNavigationController.h"
#import "MNHistoryView.h"
#import "MNInsertView.h"

@implementation MNNavigationController
- (void)viewDidLoad {
    self.navigationBar.opaque = YES;
//    self.edgesForExtendedLayout = UIExtendedEdgeNone;
    self.mnhvc = [self.storyboard instantiateViewControllerWithIdentifier:@"history"];
//    self.mnhvc.edgesForExtendedLayout = UIExtendedEdgeNone;
    [self pushViewController:self.mnhvc animated:YES];
}
- (void)reload {
    [self.mnhvc reload];
}
@end
