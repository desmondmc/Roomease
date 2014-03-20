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

@interface HPMainViewController : UIViewController <HPUINotifierDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)onLogoutPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UIView *roommateImageSubviewContainer;
- (IBAction)onSettingsPress:(id)sender;
- (IBAction)onRefreshRmPress:(id)sender;

@end
