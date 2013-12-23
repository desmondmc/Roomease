//
//  HPSigninViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/22/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPSigninViewController.h"

@interface HPSigninViewController ()

@end

@implementation HPSigninViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [_usernameTextField select:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _usernameTextField)
    {
        [_usernameHighlight setHidden:false];
        [_passwordHighlight setHidden:true];
        [_usernameClearButton setHidden:false];
        [_passwordClearButton setHidden:true];
    }
    else if (textField == _passwordTextField)
    {
        [_usernameHighlight setHidden:true];
        [_passwordHighlight setHidden:false];
        [_usernameClearButton setHidden:true];
        [_passwordClearButton setHidden:false];
    }
}

- (IBAction)onPasswordClearPress:(id)sender {
    _passwordTextField.text = @"";
}
- (IBAction)onUsernameClearPress:(id)sender {
    _usernameTextField.text = @"";
}
@end
