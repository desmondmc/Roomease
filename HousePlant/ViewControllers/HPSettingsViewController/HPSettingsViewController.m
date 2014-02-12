//
//  HPSettingsViewController.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/11/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPSettingsViewController.h"

@interface HPSettingsViewController ()

@end

@implementation HPSettingsViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSetLocationPress:(id)sender {
    HPHouse *house = [[HPHouse alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressText = [NSString stringWithFormat:@"%@ %@ %@",_houseNumberField.text,_streetField.text,_cityField.text];
    [geocoder geocodeAddressString:addressText inRegion:nil
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     NSLog(@"placemarks: %@", placemarks);
                     if ([placemarks count] > 0)
                     {
                         [house setLocation:((CLPlacemark *)[placemarks objectAtIndex:0]).location];
                         [HPCentralData saveHouseInBackgroundWithHouse:house andBlock:^(NSError *error) {
                             [CSNotificationView showInViewController:self
                                                                style:CSNotificationViewStyleSuccess
                                                              message:@"Saved Address!"];
                         }];
                     }
                     else
                     {
                         [CSNotificationView showInViewController:self
                                                            style:CSNotificationViewStyleError
                                                          message:@"Could not find address."];
                     }
                 }];
    

    
    
    
}

- (IBAction)onBackPress:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end
