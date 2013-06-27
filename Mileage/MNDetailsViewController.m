//
//  MNDetailsViewController.m
//  Mileage
//
//  Created by mattneary on 6/17/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNDetailsViewController.h"

@interface MNDetailsViewController ()

@end

@implementation MNDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == purchase)
    {
        NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *id_str = self.trip[@"id"];
        UIDocumentInteractionController *interactionController =
        [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-purchase.jpeg", [id_str intValue]]]]];
        interactionController.delegate = self;
        interactionController.UTI = @"public.jpeg";
        [interactionController presentPreviewAnimated:YES];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    people.text = self.trip[@"names"];
    purchases.text = self.trip[@"purchase"];
    destination.text = self.trip[@"location"];
    purpose.text = self.trip[@"purpose"];
    
    self.delegate.navigationItem.title = @"« History";
    // TODO: load and insert images
    NSString *id_str = self.trip[@"id"];
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    UIImage *endImage = [UIImage imageWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-end.jpeg", [id_str intValue]]]];
    UIImage *receiptImage = [UIImage imageWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-purchase.jpeg", [id_str intValue]]]];
    map.image = endImage;
    purchase.image = receiptImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    self.delegate.navigationItem.title = @"History";
}

@end
