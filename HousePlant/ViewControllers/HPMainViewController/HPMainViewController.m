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

#import "RoommateImageSubview.h"
#import "HPSettingsViewController.h"

@interface HPMainViewController ()

@end

@implementation HPMainViewController
{
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
    
    // Store a reference to the mainViewController in appdel
    kApplicationDelegate.mainViewController = self;
    
    RoommateImageSubview *roommateView = [RoommateImageSubview roommateImageSubview];
    [[self roommateImageSubviewContainer] addSubview:roommateView];
    
    if (kApplicationDelegate.locationManager == nil) {
        kApplicationDelegate.locationManager = [[HPLocationManager alloc] initWithDelegate:kApplicationDelegate.mainViewController];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //Get house from central data and check if the region attribute is set.
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
        if ([house addressText] != nil)
        {
            //There is an address. Has region been calculated and stored?
            if ([house region] == nil) {
                [kApplicationDelegate.locationManager setRegionToMonitorWithIdentifier:kHomeLocationIdentifier latitude:house.location.coordinate.latitude longitude:house.location.coordinate.longitude radius:kDefaultHouseRadius];
            }
            
            //Force request for initial state.
            
            NSSet * monitoredRegions = kApplicationDelegate.locationManager.locationManager.monitoredRegions;
            
            [kApplicationDelegate.locationManager.locationManager requestStateForRegion:kApplicationDelegate.locationManager.region];
            
        }
    }];
}

- (void) setUpProfilePictures
{
    
    [HPCentralData getRoommatesInBackgroundWithBlock:^(NSArray *roommates, NSError *error) {
        //
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

- (IBAction)onLogoutPress:(id)sender {
    [PFUser logOut];
    HPStartingViewController *startingViewController = [[HPStartingViewController alloc] init];
    [self presentViewController:startingViewController animated:NO completion:nil];
}
- (IBAction)onTestPress:(id)sender {
    [HPCentralData clearCentralData];
    HPHouse *house = [HPCentralData getHouse];
    
    NSLog(@"House Name: %@", [house houseName]);
    
    [house setHouseName:@"New Name"];
    
    [HPCentralData saveHouse:house];
    
    [HPCentralData clearCentralData];
    
    house = [HPCentralData getHouse];
    
    NSLog(@"House Name: %@", [house houseName]);
    
    house = [HPCentralData getHouse];
    
    NSLog(@"House Name: %@", [house houseName]);
}
- (IBAction)onSettingsPress:(id)sender {
    HPSettingsViewController *settingsViewController = [[HPSettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    //update the current users location on parse and the local database.
    NSLog(@"Calling did enter region...");
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        if (state == CLRegionStateInside) {
            //User is inside house location
             NSLog(@"User is inside fence...");
        }
        else
        {
            //User is outside location or inside
            NSLog(@"User is outside fence...");
        }
    }
    else
    {
        NSLog(@"Unknown region request...");
    }

}

@end

