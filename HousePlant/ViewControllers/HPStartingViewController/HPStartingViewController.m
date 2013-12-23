//
//  HPStartingViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/6/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPStartingViewController.h"
#import "HPSigninViewController.h"

@interface HPStartingViewController ()

@end

@implementation HPStartingViewController

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

- (IBAction)onLoginPress:(id)sender {
    HPSigninViewController *signinViewController = [[HPSigninViewController alloc] init];
    signinViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:signinViewController animated:YES completion:nil];
}

- (IBAction)onSignupPress:(id)sender {
}
@end
