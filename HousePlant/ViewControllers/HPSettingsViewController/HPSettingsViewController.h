//
//  HPSettingsViewController.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/11/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSettingsViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *houseNumberField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *homeLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *uploadingPhotoIndicator;
@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *useCurrentLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)onSetLocationPress:(id)sender;
- (IBAction)onBackPress:(id)sender;
- (IBAction)onSetProfilePicPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *houseDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *streetDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cityDeleteButton;
- (IBAction)onHouseDeletePress:(id)sender;
- (IBAction)onStreetDeletePress:(id)sender;
- (IBAction)onCityDeletePress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;




@end
