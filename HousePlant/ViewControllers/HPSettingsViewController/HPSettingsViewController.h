//
//  HPSettingsViewController.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/11/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSettingsViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *houseNumberField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *homeLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *uploadingPhotoIndicator;

- (IBAction)onSetLocationPress:(id)sender;
- (IBAction)onBackPress:(id)sender;
- (IBAction)onSetProfilePicPress:(id)sender;



@end
