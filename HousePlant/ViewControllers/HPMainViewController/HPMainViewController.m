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
    
    _usernameLabel.text = [NSString stringWithFormat:@"You are %@!", [PFUser currentUser].username];
    [[PFUser currentUser] fetch];
    PFObject *home = [[PFUser currentUser] objectForKey:@"home"];
    [home fetch];
    
    _houseLabel.text = [NSString stringWithFormat:@"Welcome to %@!", [home objectForKey:@"name"]];
    
    NSArray *users = [home objectForKey:@"users"];
    
    NSUInteger tempUserCount;
    if (users.count > 3) {
        tempUserCount = 4;
    }
    else
    {
        tempUserCount = users.count;
    }
    
    [self hideUnusedUserImagesWithUserCount:tempUserCount];
    
    for (int userIndex = 0; userIndex <tempUserCount; userIndex++) {
        PFUser *user = [users objectAtIndex:userIndex];
        [user fetch];
        [self getProfilePicturesWithUser:user andIndex:userIndex];
        switch (userIndex) {
            case 0:
                _houseMateName1.text = [user objectForKey:@"username"];
                break;
            case 1:
                _houseMateName2.text = [user objectForKey:@"username"];
                break;
            case 2:
                _houseMateName3.text = [user objectForKey:@"username"];
                break;
            case 3:
                _houseMateName4.text = [user objectForKey:@"username"];
                break;
            default:
                break;
        }
        
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"377 Gladstone Ave" inRegion:nil
                 completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"placemarks: %@", placemarks);
    }];
}

- (void) hideUnusedUserImagesWithUserCount:(NSUInteger)count
{
    if (count > 3) {
        return;
    }
    if (count == 1) {
        goto hide3;
    }
    if (count == 2)
    {
        goto hide2;
    }
    if (count == 3) {
        goto hide1;
    }
    
hide3:
    [_houseMateImage2 setHidden:true];
    [_houseMateName2 setHidden:true];
hide2:
    [_houseMateImage3 setHidden:true];
    [_houseMateName3 setHidden:true];
hide1:
    [_houseMateImage4 setHidden:true];
    [_houseMateName4 setHidden:true];
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

