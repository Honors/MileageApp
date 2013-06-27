//
//  MNRegisterViewController.h
//  Mileage
//
//  Created by mattneary on 6/17/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNRegisterViewController : UIViewController <NSURLConnectionDataDelegate> {
    IBOutlet UIButton *login;
    
    IBOutlet UILabel *emailLabel;
    IBOutlet UITextField *email;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UILabel *errorLabel;
    
    BOOL inRegisterMode;
}
- (IBAction)login;
- (IBAction)toggleToLogin;
- (void)reflectMode;
@property UIViewController *delegate;
@property NSMutableData *loginResp;
@end
