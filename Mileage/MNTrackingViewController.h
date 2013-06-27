//
//  MNFirstViewController.h
//  Mileage
//
//  Created by mattneary on 2/27/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import "MNInsertView.h"
#import <MapKit/MapKit.h>

@class MNTabBar;
@interface MNTrackingViewController : UIViewController <MKMapViewDelegate, MyCLControllerDelegate> {
    IBOutlet MKMapView *map;
    MyCLController *locationController;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    IBOutlet UIButton *startButton;
    IBOutlet UILabel *mileage;
    IBOutlet UIButton *nextButton;
    
    CLLocation *prevLocation;
    float mileageSum;
}

- (void)close;
- (IBAction)nextView;
- (IBAction)setStartpoint;
- (CLLocationCoordinate2D)makeCoordWithLat: (double)latitude Long: (double)longitude;
- (IBAction)setEndpoint;
- (UIImage *)getMapImage;
- (void)setResumeButton;
@property BOOL shouldCompareDistance;
@property MNInsertView *delegate;
@property NSDictionary *insertion;
@property NSNumber *idnum;
@end
