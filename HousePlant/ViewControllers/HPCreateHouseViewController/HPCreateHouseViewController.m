//
//  HPCreateHouseViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPCreateHouseViewController.h"

@interface HPCreateHouseViewController ()

@end

@implementation HPCreateHouseViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    //Cleanup view
    [_houseNameClearButton setHidden:true];
    [_passwordClearButton setHidden:true];
    [_confirmPassClearButton setHidden:true];
}


/*** User interface sheeet ***/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _houseNameField)
    {
        [_houseNameClearButton setHidden:false];
        [_passwordClearButton setHidden:true];
        [_confirmPassClearButton setHidden:true];
    }
    else if (textField == _passwordField)
    {
        [_houseNameClearButton setHidden:true];
        [_passwordClearButton setHidden:false];
        [_confirmPassClearButton setHidden:true];
    }
    else if (textField == _confirmPasswordField)
    {
        [_houseNameClearButton setHidden:true];
        [_passwordClearButton setHidden:true];
        [_confirmPassClearButton setHidden:false];
    }
}


- (IBAction)onConfirmPasswordClearPress:(id)sender {
    _confirmPasswordField.text = @"";
}
- (IBAction)onHouseNameClearPress:(id)sender {
    _houseNameField.text = @"";
}

- (IBAction)onPasswordClearPress:(id)sender {
    _passwordField.text = @"";
}
- (IBAction)onBackPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onMoveInPress:(id)sender {
    //Check if House and password are valid
    NSString *validateString = [self validateUsernameAndPasswordSubmission];
    
    if (validateString) {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:validateString];
        return;
    }
    //Create house parse object
    
    //Add current user to the house.
    //Add password and houseName to house.
    
    //load the main view.
}

- (NSString *) validateUsernameAndPasswordSubmission
{
    if (_houseNameField.text.length < 6) {
        return @"House name must be at least 6 characters.";
    }
    
    if (![_passwordField.text isEqualToString:_confirmPasswordField.text]) {
        return @"Passwords don't match.";
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"House"];
    [query whereKey:@"name" equalTo:_houseNameField.text];
    
    //Possibly put activity indicator here. That gets hidden after the query is done.
    if ([query findObjects].count > 0)
    {
        return @"House Name already taken.";
    }
    
    return nil;
}

@end
