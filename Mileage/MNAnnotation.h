//
//  MNAnnotation.h
//  Mileage
//
//  Created by mattneary on 2/27/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface MNAnnotation : NSObject <MKAnnotation>

@property NSString *title;
@property NSString *subtitle;
@property CLLocationCoordinate2D coordinate;

@end
