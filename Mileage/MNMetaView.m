//
//  MNMetaView.m
//  Mileage
//
//  Created by mattneary on 3/12/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNMetaView.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation MNMetaView
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if( [string isEqualToString:@"\n"] ) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( [mode isEqualToString:@"camera"] ) {
        if( buttonIndex == 0 ) {
            mode = @"picker";
            UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
            uiipc.delegate = self;
            uiipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:uiipc animated:YES completion:nil];
        } else {
            mode = @"camera";
            // Take picture...
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            }

            imagePickerController.delegate = self;
            [self presentModalViewController:imagePickerController animated:YES];
        }
        return;
    }
    if( buttonIndex == 0 ) {
        ABPeoplePickerNavigationController *peoplePickerController =
        [[ABPeoplePickerNavigationController alloc] init];
        peoplePickerController.peoplePickerDelegate = self;
        [self presentModalViewController:peoplePickerController animated:YES];
    } else {
        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        picker.newPersonViewDelegate = self;
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
        [self presentModalViewController:navigation animated:YES];
    }
}
- (IBAction)contacts {
    mode = @"person";
    UIActionSheet * sampleSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Use Existing Contact", @"Insert New", nil];
    
    [sampleSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sampleSheet showInView:self.view];
}
- (IBAction)location {
    mode = @"location";
    UIActionSheet * sampleSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Use Existing Location", @"Insert New Location", nil];
    
    [sampleSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sampleSheet showInView:self.view];
}
- (void)uploadAsset: (NSString *)assetName withData: (NSData *)data forUser: (NSString *)username {
    NSString *boundary = @"----------------------------7344780860da";
    NSMutableURLRequest *uploadReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dashboard.mileageapp.co/api/asset/%@", username]]];
    [uploadReq addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *bodyData = [NSMutableData data];
    
    [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"name"] dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:[[NSString stringWithFormat:@"%@\r\n", assetName] dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"filedata\"; filename=\"docs.md\"\r\nContent-Type: application/octet-stream\r\n\r\n", boundary] dataUsingEncoding:NSStringEncodingConversionAllowLossy]];
    
    [bodyData appendData:data];
    uploadReq.HTTPBody = bodyData;
    uploadReq.HTTPMethod = @"POST";
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:uploadReq delegate:self];
    [conn start];
}
- (IBAction)save {
    NSArray *credits = [self.credentials componentsSeparatedByString:@":"];
    NSString *username = credits[0];
    NSString *token = credits[1];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dashboard.mileageapp.co/api/trip/%@?token=%@", username, token]]];
    NSError *error;    
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{
         @"purpose": purpose.text,
         @"purchase": purchase.text,
         @"location": location.text,
         @"names": names.text,
         @"distance": self.distance,
         @"id": self.idnum
     } options:nil error:&error];
    req.HTTPMethod = @"POST";
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
    [conn start];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        // Asynchronously upload all image assets
        if( attachment.image != nil ) {
            [self uploadAsset:[NSString stringWithFormat:@"%@-purchase", self.idnum] withData:UIImageJPEGRepresentation(attachment.image, 1) forUser:username];
        }
        [self uploadAsset:[NSString stringWithFormat:@"%@-start", self.idnum] withData:UIImageJPEGRepresentation(self.startImage, 1) forUser:username];
        [self uploadAsset:[NSString stringWithFormat:@"%@-end", self.idnum] withData:UIImageJPEGRepresentation(self.endImage, 1) forUser:username];
    });
    
    [self.delegate dismiss];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if( [mode isEqualToString:@"camera"] ) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        attachment.image = image;
        [self dismissViewControllerAnimated:YES completion:nil];
        // write image...
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSData *data = UIImageJPEGRepresentation(image, 1);
            NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-purchase.jpeg", [self.insertion[@"id"] intValue]]] contents:data attributes:nil];
        });
        
        return;
    }
    
    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
        // code to handle the asset here
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:referenceURL resultBlock:^(ALAsset *asset) {            
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                attachment.image = [UIImage imageWithCGImage:[myasset thumbnail]];
                                
                uint8_t* buffer = malloc([rep size]);
                NSError* error = NULL;
                NSUInteger bytes = [rep getBytes:buffer fromOffset:0 length:[rep size] error:&error];
                
                NSData *defaultRepresentationData;
                if (bytes == [rep size]) {
                    defaultRepresentationData = [NSData dataWithBytes:buffer length:bytes];
                    [fileManager createFileAtPath:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-purchase.jpeg", [self.insertion[@"id"] intValue]]] contents:defaultRepresentationData attributes:nil];
                } else {
                    //handle error in data writing
                }
            };
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                //handle error in data reading
            };
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            
            //Once url is checked, open asset
            [assetslibrary assetForURL:referenceURL resultBlock:resultblock failureBlock:failureblock];
            
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
        }];
    } failureBlock:^(NSError *err){
        //handle error
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)attachImage {
    mode = @"camera";
    UIActionSheet * sampleSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Use Existing Picture", @"Take New Picture", nil];
    
    [sampleSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sampleSheet showInView:self.view];
}
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    if( [mode isEqualToString:@"person"] ) {
        names.text = CFBridgingRelease(ABRecordCopyCompositeName(person));
    } else {
        ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
        NSMutableDictionary *address = ((__bridge NSMutableDictionary *)ABMultiValueCopyValueAtIndex(addresses, 0));
        NSString *street = address[@"Street"];
        NSString *city = address[@"City"];
        NSString *state = address[@"State"];
        location.text = [NSString stringWithFormat:@"%@, %@ %@", street, city, state];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    if( [mode isEqualToString:@"person"] ) {
        names.text = CFBridgingRelease(ABRecordCopyCompositeName(person));
    } else {
        ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
        NSMutableDictionary *address = ((__bridge NSMutableDictionary *)ABMultiValueCopyValueAtIndex(addresses, 0));
        NSString *street = address[@"Street"];
        NSString *city = address[@"City"];
        NSString *state = address[@"State"];
        location.text = [NSString stringWithFormat:@"%@, %@ %@", street, city, state];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {    
    return NO;
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
//    self.edgesForExtendedLayout = UIExtendedEdgeNone;
    mapPreview.image = self.mapImage;
    purpose.delegate = self;
    purchase.delegate = self;
    location.delegate = self;
    names.delegate = self;
    attachmentFrame.transform = CGAffineTransformMakeRotation(.12);
    scroll.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    [location becomeFirstResponder];
    
    NSError *error;
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.credentials = [NSString stringWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:@"/credentials.txt"] encoding:NSStringEncodingConversionAllowLossy error:&error];
}
@end
