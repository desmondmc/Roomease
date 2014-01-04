//
//  HPJoinHouseViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPJoinHouseViewController.h"

@interface HPJoinHouseViewController ()

@end

@implementation HPJoinHouseViewController

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

- (IBAction)onBackPress:(id)sender {
}
- (IBAction)onHouseNameClearPress:(id)sender {
    _houseNameTextField.text = @"";
}

- (IBAction)onPasswordClearPress:(id)sender {
    _passwordTextField.text = @"";
}
@end
