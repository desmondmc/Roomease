//
//  HPCreateHouseViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPCreateHouseViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
- (IBAction)onConfirmPasswordClearPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *houseNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)onHouseNameClearPress:(id)sender;
- (IBAction)onPasswordClearPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmPassClearButton;
@property (weak, nonatomic) IBOutlet UIButton *houseNameClearButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordClearButton;
- (IBAction)onBackPress:(id)sender;
- (IBAction)onMoveInPress:(id)sender;

@end
