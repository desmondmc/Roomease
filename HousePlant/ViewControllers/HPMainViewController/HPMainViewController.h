//
//  HPMainViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/28/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HPMainViewController : UIViewController <CLLocationManagerDelegate>
- (IBAction)onEnableLocationServicesPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)onLogoutPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
- (IBAction)onTestPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *roommateImageSubviewContainer;
- (IBAction)onSettingsPress:(id)sender;

@end
