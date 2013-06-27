//
//  MNSecondViewController.m
//  Mileage
//
//  Created by mattneary on 2/27/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNSecondViewController.h"

@interface MNSecondViewController ()

@end

@implementation MNSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *saves = [NSArray arrayWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:@"saves.plist"]];    
    
    UIImage *startImage = [UIImage imageWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-start.jpeg", [saves[0][@"id"] intValue]]]];
    UIImage *endImage = [UIImage imageWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-end.jpeg", [saves[0][@"id"] intValue]]]];
    distance.titleLabel.text = [NSString stringWithFormat:@"%@ miles", saves[0][@"distance"]];
    
    img1.image = startImage;
    img2.image = endImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
