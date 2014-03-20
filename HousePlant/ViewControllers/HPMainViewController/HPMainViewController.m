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
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.1")) {
        systemVersion = @"7.0";
    }
    
    //Save the current iOS version that this user is running.
    [[PFUser currentUser] setObject:systemVersion forKey:@"iosVersion"];

    [[HPUINotifier sharedUINotifier] addDelegate:self];
    
    // Store a reference to the mainViewController in appdel
    kApplicationDelegate.mainViewController = self;
    
    roommateView = [RoommateImageSubview roommateImageSubview];
    [[self roommateImageSubviewContainer] addSubview:roommateView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[HPLocationManager sharedLocationManager] updateAtHomeStatus];
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
    [[[PFInstallation currentInstallation] objectForKey:@"channels"] removeAllObjects];
    [[PFInstallation currentInstallation] saveInBackground];
    [PFUser logOut];
    HPStartingViewController *startingViewController = [[HPStartingViewController alloc] init];
    [self presentViewController:startingViewController animated:NO completion:nil];
}

//THIS METHOD IS USED FOR DEBUGGING SHIT
- (IBAction)onTestPress:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:roommatesSyncRequest], @"syncRequestKey", [PFUser currentUser].objectId, @"src_usr", nil];
    [HPPushHelper sendNotificationWithDataToEveryoneInHouseButMe:dict andAlert:[NSString stringWithFormat:@"%@ Sorry testing notifications.", [[PFUser currentUser] username]]];
    
//    [HPPushHelper sendNotificationWithDataToEveryoneInHouseButMe:dict andAlert: nil];

}


- (IBAction)onSettingsPress:(id)sender {
    HPSettingsViewController *settingsViewController = [[HPSettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

- (IBAction)onRefreshRmPress:(id)sender {
    //Starts a sync request. Will be called back on resyncUIWithDictionary.
    [[HPLocationManager sharedLocationManager] updateAtHomeStatus];
}


#pragma mark - Notification Handlers

- (void) receiveNotificationAppActive:(NSNotification *) notification
{
    //double delayInSeconds = 10.0;
    //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
    [[HPLocationManager sharedLocationManager] updateAtHomeStatus];
    //});
    
}

#pragma mark - HPUINotifierDelegate

-(void) resyncUIWithDictionary:(NSDictionary *)uiChanges
{
    if ([[uiChanges objectForKey:kRefreshRoommatesKey] boolValue] == YES)
    {
        for (UIView *view in [[self roommateImageSubviewContainer]subviews]) {
            [view removeFromSuperview];
        }
        roommateView = [RoommateImageSubview roommateImageSubview];
        [[self roommateImageSubviewContainer] addSubview:roommateView];
    }
}

@end

