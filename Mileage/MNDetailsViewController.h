//
//  MNDetailsViewController.h
//  Mileage
//
//  Created by mattneary on 6/17/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNDetailsViewController : UIViewController {
    IBOutlet UILabel *destination;
    IBOutlet UILabel *purpose;
    IBOutlet UILabel *people;
    IBOutlet UILabel *purchases;
    
    IBOutlet UIImageView *purchase;
    IBOutlet UIImageView *map;
}

@property NSDictionary *trip;
@property UIViewController *delegate;

@end
