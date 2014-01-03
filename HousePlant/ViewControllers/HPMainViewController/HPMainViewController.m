//
//  HPMainViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/28/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPMainViewController.h"
#import <Parse/Parse.h>

@interface HPMainViewController ()

@end

@implementation HPMainViewController
{
    CLLocationManager *locationManager;
}
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
    
    _usernameLabel.text = [NSString stringWithFormat:@"Hello %@!", [PFUser currentUser].username];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"377 Gladstone Ave" inRegion:nil
                 completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"placemarks: %@", placemarks);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnableLocationServicesPress:(id)sender {
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_addressField.text inRegion:nil
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     NSLog(@"placemarks: %@", placemarks);
                 }];
}
- (IBAction)onLogoutPress:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
