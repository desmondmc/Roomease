//
//  HPCreateHouseViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPCreateHouseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
- (IBAction)onConfirmPasswordClearPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *houseNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)onHouseNameClearPress:(id)sender;
- (IBAction)onPasswordClearPress:(id)sender;

@end
