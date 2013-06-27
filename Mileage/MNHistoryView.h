//
//  MNHistoryView.h
//  Mileage
//
//  Created by mattneary on 3/9/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNHistoryView : UITableViewController <UIDocumentInteractionControllerDelegate>

@property NSArray *items;
@property NSString *credentials;
- (void)reload;
@end
