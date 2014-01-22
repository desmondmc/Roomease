//
//  HPStartingViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/6/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPStartingViewController.h"
#import "HPSigninViewController.h"
#import "HPSignupViewController.h"

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
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    if (screenSize.height > 480.0f)
    {
        /*Do iPhone 5 stuff here.*/
        [_buttonView setFrame:CGRectMake(0, 425, _buttonView.frame.size.width, _buttonView.frame.size.height)];
        [_mainLogo setFrame:CGRectMake(56, 70, _mainLogo.frame.size.width, _mainLogo.frame.size.height)];
        
    } else {
        /*Do iPhone Classic stuff here.*/
        [_buttonView setFrame:CGRectMake(0, 338, _buttonView.frame.size.width, _buttonView.frame.size.height)];
    }
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
    HPSignupViewController *signunViewController = [[HPSignupViewController alloc] init];
    signunViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:signunViewController animated:YES completion:nil];
}
@end
