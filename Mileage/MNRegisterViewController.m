//
//  MNRegisterViewController.m
//  Mileage
//
//  Created by mattneary on 6/17/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNRegisterViewController.h"
#import "MNHistoryView.h"

@interface MNRegisterViewController ()

@end

@implementation MNRegisterViewController

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.loginResp appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:self.loginResp options:nil error:&error];
    if( [resp[@"success"] intValue] ) {
        NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        [[NSString stringWithFormat:@"matt:%@", resp[@"token"]] writeToFile:[documentFolderPath stringByAppendingPathComponent:@"/credentials.txt"] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&error];
        [self.delegate dismissViewControllerAnimated:YES completion:nil];
    } else {
        errorLabel.text = resp[@"error"];
        errorLabel.hidden = NO;
    }
    
    [self reflectMode];
}
- (IBAction)toggleToLogin {
    inRegisterMode = NO;
    emailLabel.hidden = YES;
    email.hidden = YES;
    login.titleLabel.text = @"Login";
}
- (void)reflectMode {
    if( inRegisterMode ) {
        login.titleLabel.text = @"Signup";
    } else {
        login.titleLabel.text = @"Login";
    }
}
- (IBAction)login {
    errorLabel.hidden = YES;
    if( inRegisterMode ) {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dashboard.mileageapp.co/api/register"]];
        req.HTTPBody = [[NSString stringWithFormat:@"{\"username\": \"%@\",\"password\":\"%@\",\"email\":\"%@\"}", username.text, password.text, email.text] dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        req.HTTPMethod = @"POST";
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
        [conn start];
        if( conn ) {
            self.loginResp = [[NSMutableData alloc] initWithCapacity:1024*3];
        }
    } else {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dashboard.mileageapp.co/api/login"]];
        req.HTTPBody = [[NSString stringWithFormat:@"{\"username\": \"%@\",\"password\":\"%@\"}", username.text, password.text] dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        req.HTTPMethod = @"POST";
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
        [conn start];
        if( conn ) {
            self.loginResp = [[NSMutableData alloc] initWithCapacity:1024*3];
        }                
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    inRegisterMode = YES;
    [username becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
