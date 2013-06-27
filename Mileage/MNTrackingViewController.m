//
//  MNFirstViewController.m
//  Mileage
//
//  Created by mattneary on 2/27/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNTrackingViewController.h"
#import "MyCLController.h"
#import "MNAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MNAnnotation.h"
#import "MNTabBar.h"
#import "MNMetaView.h"

@interface MNTrackingViewController ()

@end

@implementation MNTrackingViewController
@synthesize shouldCompareDistance;
@synthesize delegate;

// TODO: CLLocationManager setAccuracy

- (IBAction)nextView {
    MNMetaView *mnmv = [self.storyboard instantiateViewControllerWithIdentifier:@"metaview"];
    mnmv.insertion = [NSMutableDictionary dictionaryWithDictionary:self.insertion];
    mnmv.delegate = self.delegate;
    mnmv.mapImage = img2.image;
    mnmv.startImage = img1.image;
    mnmv.endImage = img2.image;
    mnmv.distance = [NSNumber numberWithFloat:mileageSum];
    mnmv.idnum = self.idnum;
    [self.delegate pushViewController:mnmv animated:YES];
}
- (void)close {    
    [self.delegate dismiss];
}
- (void)setResumeButton {
    [startButton setTitle:@"Resume" forState:UIControlStateNormal];
}
- (IBAction)setStartpoint {
    img2.image = nil;
    if( [startButton.titleLabel.text isEqualToString:@"Resume"] ) {
        shouldCompareDistance = YES;
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        mileageSum = 0;
        mileage.text = @"0.0 mi";
        img1.image = [self getMapImage];
        shouldCompareDistance = YES;
    }
}
- (IBAction)setEndpoint {
    img2.image = [self getMapImage];
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
    int ident = floor(abs(random())*1000);
    self.idnum = [NSNumber numberWithInt: ident];
    self.insertion = @{ @"distance": [NSNumber numberWithFloat:mileageSum], @"id": [NSNumber numberWithInt: ident]  };
    
    NSData *writeStart = UIImageJPEGRepresentation(img1.image, 1.0);
    NSData *writeEnd = UIImageJPEGRepresentation(img2.image, 1.0);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-start.jpeg", ident]] contents:writeStart attributes:nil];
    [fileManager createFileAtPath:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-end.jpeg", ident]] contents:writeEnd attributes:nil];
        
    shouldCompareDistance = NO;
    nextButton.hidden = NO;
    
    // Remove annotation
    NSMutableArray *locs = [[NSMutableArray alloc] init];
    for (id <MKAnnotation> annot in [map annotations])
    {
        if ( [annot isKindOfClass:[ MKUserLocation class]] ) {
        }
        else {
            [locs addObject:annot];
        }
    }
    [map removeAnnotations:locs];
    
    // let updater know we've started anew
    prevLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
}
- (CLLocationCoordinate2D)makeCoordWithLat: (double)latitude Long: (double)longitude {
    CLLocationCoordinate2D coord = {.latitude =  latitude, .longitude =  longitude};    
    return coord;
}
- (void)setRegionLat: (double)latitude Long: (double)longitude {
    CLLocationCoordinate2D coord = [self makeCoordWithLat:latitude Long:longitude];
    MKCoordinateSpan span = {.latitudeDelta = 0.03, .longitudeDelta =  0.03};
    MKCoordinateRegion region = {coord, span};
    [map setRegion:region];
}
- (void)dropPinLat: (double)latitude Long: (double)longitude {
    MNAnnotation *annotation = [[MNAnnotation alloc] init];
    annotation.title = @"Start";
    annotation.coordinate = [self makeCoordWithLat:latitude Long:longitude];
    [map addAnnotation:annotation];
}
- (UIImage *)getMapImage {
    UIGraphicsBeginImageContext(map.bounds.size);
    [map.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    return mapImage;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIExtendedEdgeNone;
	// Do any additional setup after loading the view, typically from a nib.
    
    MNAppDelegate *appDelegate = (MNAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mntvc = self;
    
    
    locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
    
    prevLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    
    mileage.text = @"0.0 mi";
    mileageSum = 0;
    shouldCompareDistance = NO;
    
    map.showsUserLocation = YES;
    
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // TODO: create initial plist file
    //[@[] writeToFile:[documentFolderPath stringByAppendingPathComponent:@"saves.plist"] atomically:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [self.navigationItem setLeftBarButtonItem:item];
}
- (void)locationUpdate:(CLLocation *)location {
    if( !shouldCompareDistance ) {
        [self setRegionLat:location.coordinate.latitude Long:location.coordinate.longitude];        
        return;
    }
    
    if( prevLocation.coordinate.latitude == 0 ) {
        [self dropPinLat:location.coordinate.latitude Long:location.coordinate.longitude];
        [self setRegionLat:location.coordinate.latitude Long:location.coordinate.longitude];
        prevLocation = location;
    }
    
    // wait for deviation from a point by at least 5m
    double deviation = [location distanceFromLocation:prevLocation];
    if( deviation >= 5 ) {
        mileageSum += deviation;
        int dist = mileageSum;
        dist = round((double)dist/1624*10);
        mileage.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:(double)dist/10]];
    
        [self setRegionLat:location.coordinate.latitude Long:location.coordinate.longitude];
        
        prevLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    }
}


@end
