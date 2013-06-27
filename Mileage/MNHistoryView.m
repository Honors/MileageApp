//
//  MNHistoryView.m
//  Mileage
//
//  Created by mattneary on 3/9/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "MNHistoryView.h"
#import "MNDetailsViewController.h"
#import "MNRegisterViewController.h"

@implementation MNHistoryView

- (NSArray *)reversedArray: (NSArray *)array {
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    for (id element in enumerator) {
        [array2 addObject:element];
    }
    return array2;
}
- (void)reload {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,        NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSError *error;
        NSArray *credits = [self.credentials componentsSeparatedByString:@":"];
        NSString *username = credits[0];
        NSString *token = credits[1];
        NSString *fetch = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dashboard.mileageapp.co/api/trips/%@?token=%@", username, token]] encoding:NSStringEncodingConversionAllowLossy error:&error];
        NSDictionary *resp;
        if( error || fetch == nil ) {
            NSString *cachePath = [documentsDirectory stringByAppendingPathComponent:@"trips.plist"];
            if( [[NSFileManager defaultManager] fileExistsAtPath:cachePath] ) {
                // read form cache if available
                resp = @{@"trips":[NSArray arrayWithContentsOfFile:cachePath]};
            } else {
                // fallback to empty array
                resp = @{ @"trips": @[] };
            }
        } else {
            resp = [NSJSONSerialization JSONObjectWithData:[fetch dataUsingEncoding:NSStringEncodingConversionAllowLossy] options:NSJSONReadingAllowFragments error:&error];
        }
                
        
        self.items = [self reversedArray:resp[@"trips"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
            [self.refreshControl endRefreshing];
        });
        
        // save to file
        NSString *savedPath = [documentsDirectory  stringByAppendingPathComponent:@"trips.plist"];
        [resp[@"trips"] writeToFile:savedPath atomically:YES];
    });
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
- (void)export {
    NSString *output = @"\"Distance\", \"Location\", \"Purpose\", \"People\"\n";
    for( NSDictionary *item in self.items ) {
        output = [output stringByAppendingFormat:@"\"%@\", \"%@\", \"%@\", \"%@\"\n", item[@"distance"], item[@"location"], item[@"purpose"], item[@"names"]];
    }
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSError *error = [[NSError alloc] init];
    [output writeToFile:[documentFolderPath stringByAppendingPathComponent:@"export.txt"] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&error];
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[documentFolderPath stringByAppendingPathComponent:@"export.txt"]]];
    interactionController.delegate = self;
    interactionController.UTI = @"public.comma-separated-values-text";
    [interactionController presentPreviewAnimated:YES];
}
- (void)viewDidLoad {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    self.refreshControl = refresh;
    [refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.items = [[NSArray alloc] init];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"History";
    self.navigationController.navigationBar.opaque = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(export)];
    
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if( ![[NSFileManager defaultManager] fileExistsAtPath:[documentFolderPath stringByAppendingPathComponent:@"/credentials.txt"]] ) {
        MNRegisterViewController *mnrvc = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
        mnrvc.delegate = self;
        [self presentViewController:mnrvc animated:YES completion:nil];
    } else {
        NSError *error;
        self.credentials = [NSString stringWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:@"/credentials.txt"] encoding:NSStringEncodingConversionAllowLossy error:&error];
        [self reload];
    }
}
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"route"];
    NSDictionary *item = [self.items objectAtIndex:[indexPath row]];
    
    NSArray *contentSubviewsCell =  [[cell subviews][0] subviews];
    UIImageView *img1 = contentSubviewsCell[1];
    UIImageView *img2 = contentSubviewsCell[0];
    UILabel *distance = contentSubviewsCell[2];
    
    distance.font = [UIFont systemFontOfSize:33];
    
    UIImage *startImage = [UIImage imageWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-start.jpeg", [item[@"id"] intValue]]]];
    UIImage *endImage = [UIImage imageWithContentsOfFile:[documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-end.jpeg", [item[@"id"] intValue]]]];
    
    img1.image = startImage;
    img2.image = endImage;    
    
    int dist = [item[@"distance"] intValue];
    dist = round((double)dist/1624*10);
    distance.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:(double)dist/10]];
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"openTripDetails"] ) {
        MNDetailsViewController *mncvc = segue.destinationViewController;
        mncvc.trip = self.items[[self.tableView indexPathForSelectedRow].row];
        mncvc.delegate = self;
    }
}
@end
