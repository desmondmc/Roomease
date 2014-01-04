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
@end
