//
//  MNInsertView.h
//  Mileage
//
//  Created by mattneary on 3/12/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNTabBar.h"

@interface MNInsertView : UINavigationController
- (void)dismiss;
@property MNTabBar *delegate;
@end
