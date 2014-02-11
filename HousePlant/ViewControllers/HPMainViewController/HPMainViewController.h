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
@property (weak, nonatomic) IBOutlet UIImageView *houseMateImage1;
@property (weak, nonatomic) IBOutlet UIImageView *houseMateImage2;
@property (weak, nonatomic) IBOutlet UIImageView *houseMateImage3;
@property (weak, nonatomic) IBOutlet UIImageView *houseMateImage4;
@property (weak, nonatomic) IBOutlet UILabel *houseMateName1;
@property (weak, nonatomic) IBOutlet UILabel *houseMateName2;
@property (weak, nonatomic) IBOutlet UILabel *houseMateName3;
@property (weak, nonatomic) IBOutlet UILabel *houseMateName4;
- (IBAction)onTestPress:(id)sender;

@end
