//
//  HPNoHomeViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPNoHomeViewController.h"
#import "HPCreateHouseViewController.h"
#import "HPJoinHouseViewController.h"

@interface HPNoHomeViewController ()

@end

@implementation HPNoHomeViewController

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

- (IBAction)onCreateHousePress:(id)sender {
    //Load CreateHouseView.
    HPCreateHouseViewController *createViewController = [[HPCreateHouseViewController alloc] init];
    createViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:createViewController animated:YES completion:nil];
}

- (IBAction)onJoinHousePress:(id)sender {
    //Load JoinHouseView
    HPJoinHouseViewController *joinHouseViewController = [[HPJoinHouseViewController alloc] init];
    joinHouseViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:joinHouseViewController animated:YES completion:nil];
}

- (IBAction)onBackPress:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
