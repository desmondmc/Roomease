//
//  HPMainViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/28/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HPUINotifierDelegate.h"
#import "HPToDoListDataSource.h"

@interface HPMainViewController : UIViewController <HPUINotifierDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *roommateImageSubviewContainer;
@property (strong, nonatomic) HPToDoListDataSource *tableViewDataSource;

- (IBAction)onSettingsPress:(id)sender;
- (IBAction)onRefreshRmPress:(id)sender;

@end
