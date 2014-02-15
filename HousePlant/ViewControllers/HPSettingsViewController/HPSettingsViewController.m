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
    
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        _homeLocationLabel.text = [house addressText];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSetLocationPress:(id)sender {
    HPHouse *house = [[HPHouse alloc] init];

    if (kApplicationDelegate.hpLocationManager == nil) {
        [HPLocationManager initHPLocationManagerWithDelegate:kApplicationDelegate.mainViewController];
    }
    
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressText = [NSString stringWithFormat:@"%@ %@ %@",_houseNumberField.text,_streetField.text,_cityField.text];
    [geocoder geocodeAddressString:addressText inRegion:nil
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     NSLog(@"placemarks: %@", placemarks);
                     if ([placemarks count] > 0)
                     {
                         CLPlacemark *placeMark = ((CLPlacemark *)[placemarks objectAtIndex:0]);
                         
                         //placeMark.location.coordinate.latitude
                         [HPLocationManager setRegionToMonitorWithIdentifier:kHomeLocationIdentifier latitude:placeMark.location.coordinate.latitude longitude:placeMark.location.coordinate.longitude radius:kDefaultHouseRadius];
                         
                         [house setLocation:placeMark.location];
                         [house setAddressText:addressText];
                         
                         [HPCentralData saveHouseInBackgroundWithHouse:house andBlock:^(NSError *error) {
                             if (!error) {
                                 [CSNotificationView showInViewController:self
                                                                    style:CSNotificationViewStyleSuccess
                                                                  message:@"Saved Address!"];
                             }

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
- (IBAction)onTestLocationPress:(id)sender {
    //Force request for initial state.
    NSString *locationErrorString = [HPLocationManager checkLocationServicePermissions];
    if (locationErrorString != nil) {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:locationErrorString];
    }
    else
    {
        [HPLocationManager requestStateForCurrentHouseLocation];
    }
}
@end
