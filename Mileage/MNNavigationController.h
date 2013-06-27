//
//  MNNavigationController.h
//  Mileage
//
//  Created by mattneary on 3/10/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNHistoryView.h"

@interface MNNavigationController : UINavigationController
- (void)reload;
@property MNHistoryView *mnhvc;
@end
