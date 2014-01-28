//
//  HPMainViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/28/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPMainViewController.h"
#import "HPStartingViewController.h"
#import "AMPAvatarView.h"

@interface HPMainViewController ()

@end

@implementation HPMainViewController
{
    CLLocationManager *locationManager;
    NSDictionary *imageForPFUser;
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
    
    // Create a new Person in the current thread context
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    defaults setObject:<#(id)#> forKey:<#(NSString *)#>
    [defaults setObject:firstName forKey:@"firstName"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"377 Gladstone Ave" inRegion:nil
                 completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"placemarks: %@", placemarks);
    }];
}


- (void) getProfilePicturesWithUser:(PFUser *)user andIndex:(int)index
{
    AMPAvatarView *avatar2;
    avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(8, 79, 58, 58)];
    [self.view addSubview:avatar2];
    [avatar2 setHidden:YES];
    
    [avatar2 setBorderWith:0.0];
    [avatar2 setShadowRadius:0.0];
    PFFile *profilePic = [user objectForKey:@"profilePic"];
    UIImage *profileImage = [UIImage imageWithData:[profilePic getData]];
    avatar2.image = profileImage;
    
    [avatar2 setHidden:NO];
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
    HPStartingViewController *startingViewController = [[HPStartingViewController alloc] init];
    [self presentViewController:startingViewController animated:NO completion:nil];
}
@end

