//
//  MNMetaView.h
//  Mileage
//
//  Created by mattneary on 3/12/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MNInsertView.h"

@interface MNMetaView : UIViewController <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UITextField *names;
    IBOutlet UITextField *location;
    IBOutlet UITextField *purpose;
    IBOutlet UITextField *purchase;
    IBOutlet UIImageView *attachment;
    IBOutlet UIView *attachmentFrame;
    IBOutlet UIImageView *mapPreview;
    IBOutlet UIScrollView *scroll;
    NSString *mode;
}
@property NSMutableDictionary *insertion;
@property UIImage *mapImage;
@property MNInsertView *delegate;
@property NSNumber *distance;

@property UIImage *startImage;
@property UIImage *endImage;

@property NSString *credentials;
@property NSNumber *idnum;
- (IBAction)contacts;
- (IBAction)location;
- (IBAction)save;
- (IBAction)attachImage;
@end
