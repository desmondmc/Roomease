//
//  HPSignupViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/22/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSignupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)onSignupPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *usernameClearButton;
- (IBAction)onUsernameClearButtonPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *passwordClearButton;
- (IBAction)onPasswordClearButtonPress:(id)sender;

@end
