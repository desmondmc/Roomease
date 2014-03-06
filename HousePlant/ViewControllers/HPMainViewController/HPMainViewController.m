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
#import "HPUINotifier.h"

@interface HPMainViewController ()

@end

@implementation HPMainViewController
{
    RoommateImageSubview *roommateView;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationAppActive:)
                                                 name:NOTIFICATION_APP_BECAME_ACTIVE
                                               object:nil];

    [[HPUINotifier sharedUINotifier] addDelegate:self];
    
    // Store a reference to the mainViewController in appdel
    kApplicationDelegate.mainViewController = self;
    
    roommateView = [RoommateImageSubview roommateImageSubview];
    [[self roommateImageSubviewContainer] addSubview:roommateView];
    
    if (kApplicationDelegate.hpLocationManager == nil) {
        [HPLocationManager initHPLocationManagerWithDelegate:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [HPLocationManager requestStateForCurrentHouseLocation];
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

//THIS METHOD IS USED FOR DEBUGGING SHIT
- (IBAction)onTestPress:(id)sender {
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:roommatesSyncRequest], @"syncRequestKey", [PFUser currentUser].objectId, @"src_usr", nil];
        
        [HPPushHelper sendNotificationWithData:dict toChannel:house.houseName andAlert:[NSString stringWithFormat:@"%@ just got home!!", [[PFUser currentUser] username]]];
    }];
}


- (IBAction)onSettingsPress:(id)sender {
    HPSettingsViewController *settingsViewController = [[HPSettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

- (IBAction)onRefreshRmPress:(id)sender {
#warning this should be smarter. Instead of clearingCentralData HPCentralData should pull from parse if a network connection is available.
    [HPCentralData clearCentralData];
    for (UIView *view in [[self roommateImageSubviewContainer]subviews]) {
        [view removeFromSuperview];
    }
    roommateView = [RoommateImageSubview roommateImageSubview];
    [[self roommateImageSubviewContainer] addSubview:roommateView];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    //update the current users location on parse and the local database.
    NSLog(@"Calling did enter region...");
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        //User is inside house location
        NSLog(@"User is inside fence...");
        HPRoommate *roommate = [[HPRoommate alloc] init];
        [roommate setAtHome:[NSNumber numberWithBool:true]];
        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
    }
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Hey!"
//                                                          message:@"You just arrived at your home!"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles: nil];
//    
//    [myAlertView show];
    
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:roommatesSyncRequest], @"syncRequestKey", [PFUser currentUser].objectId, @"src_usr", nil];
        
        [HPPushHelper sendNotificationWithData:dict toChannel:house.houseName andAlert:[NSString stringWithFormat:@"%@ just got home!!", [[PFUser currentUser] username]]];
    }];

}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    //update the current users location on parse and the local database.
    NSLog(@"Calling did exit region...");
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        //User is inside house location
        NSLog(@"User is outside fence...");
        HPRoommate *roommate = [[HPRoommate alloc] init];
        [roommate setAtHome:[NSNumber numberWithBool:false]];
        
        
        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Hey!"
//                                                              message:@"You just left your home!"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles: nil];
//        
//        [myAlertView show];
        
        [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
            //
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:roommatesSyncRequest], @"syncRequestKey", [PFUser currentUser].objectId, @"src_usr", nil];
            
            [HPPushHelper sendNotificationWithData:dict toChannel:house.houseName andAlert:[NSString stringWithFormat:@"%@ just left home!!", [[PFUser currentUser] username]]];
        }];
        return;
    }
}


- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
#warning The user is saved everytime this gets called. The user should only be saved if atHome status changes.
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        if (state == CLRegionStateInside) {
            //User is inside house location
            NSLog(@"User is inside fence...");
            HPRoommate *roommate = [[HPRoommate alloc] init];
            [roommate setAtHome:[NSNumber numberWithBool:true]];
            [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
        }
        else
        {
            //User is outside location or inside
            NSLog(@"User is outside fence...");
            HPRoommate *roommate = [[HPRoommate alloc] init];
            [roommate setAtHome:[NSNumber numberWithBool:false]];
            [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
        }
    }
    else
    {
        NSLog(@"Unknown region request...");
    }
}

#pragma mark - Notification Handlers

- (void) receiveNotificationAppActive:(NSNotification *) notification
{
    [self onRefreshRmPress:nil];
}

#pragma mark - HPUINotifierDelegate

-(void) resyncUIWithDictionary:(NSDictionary *)uiChanges
{
    if ([[uiChanges objectForKey:kRefreshRoommatesKey] boolValue] == YES)
    {
        [self onRefreshRmPress:nil];
    }
}

@end

