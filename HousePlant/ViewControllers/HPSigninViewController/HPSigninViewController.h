//
//  HPSigninViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/22/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSigninViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *usernameHighlight;
@property (weak, nonatomic) IBOutlet UIImageView *passwordHighlight;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)onUsernameClearPress:(id)sender;
- (IBAction)onPasswordClearPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *usernameClearButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordClearButton;


@end
