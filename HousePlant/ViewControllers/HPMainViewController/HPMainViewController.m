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
#import "HPListTableViewCell.h"

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
    
    roommateView = [RoommateImageSubview initRoommateImageSubview];
    [[self roommateImageSubviewContainer] addSubview:roommateView];
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

//THIS METHOD IS USED FOR DEBUGGING SHIT
- (IBAction)onTestPress:(id)sender {
    [HPCentralData getCurrentUserInBackgroundWithBlock:^(HPRoommate *roommate, NSError *error) {
        
        if ([[roommate atHomeString] isEqualToString:@"false"]) {
            [roommate setAtHomeString:@"true"];
        }
        else
        {
            [roommate setAtHomeString:@"false"];
        }
        
        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
    }];
}


- (IBAction)onSettingsPress:(id)sender {
    HPSettingsViewController *settingsViewController = [[HPSettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

- (IBAction)onRefreshRmPress:(id)sender {
    //Starts a sync request. Will be called back on resyncUIWithDictionary.
    [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hpListTableViewCell"];

    if (cell == nil) {
        //There was no reusablecell to dequeue
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row == 1) {
        cell.entryTitle.text = @"Take out garbage before Jeremiah farts in all of our mouths.";
        cell.entryDate.text = @"March 13, 2014 at";
        cell.entryTime.text = @"10:45AM";
    }
    else if(indexPath.row == 2) {
        cell.entryTitle.text = @"Buy red-solo cups for the party this weekend.";
        cell.entryDate.text = @"March 17, 2014 at";
        cell.entryTime.text = @"5:23AM";
    }
    else if(indexPath.row == 3) {
        cell.entryTitle.text = @"Pay Rogers Cable bill $120.";
        cell.entryDate.text = @"March 15, 2014 at";
        cell.entryTime.text = @"2:45PM";
    }
    else if(indexPath.row == 4) {
        cell.entryTitle.text = @"Buy red-solo cups for the party this weekend.";
        cell.entryDate.text = @"March 17, 2014 at";
        cell.entryTime.text = @"5:23AM";
    }
    else if(indexPath.row == 5) {
        cell.entryTitle.text = @"Pay Rogers Cable bill $120.";
        cell.entryDate.text = @"March 15, 2014 at";
        cell.entryTime.text = @"2:45PM";
    }
    else if(indexPath.row == 6) {
        cell.entryTitle.text = @"Buy red-solo cups for the party this weekend.";
        cell.entryDate.text = @"March 17, 2014 at";
        cell.entryTime.text = @"5:23AM";
    }
    else if(indexPath.row == 7) {
        cell.entryTitle.text = @"Pay Rogers Cable bill $120.";
        cell.entryDate.text = @"March 15, 2014 at";
        cell.entryTime.text = @"2:45PM";
    }

    
    return cell;
}

#pragma mark - Notification Handlers

- (void) receiveNotificationAppActive:(NSNotification *) notification
{
    [[HPLocationManager sharedLocationManager] updateAtHomeStatus];
}

#pragma mark - HPUINotifierDelegate

-(void) resyncUIWithDictionary:(NSDictionary *)uiChanges
{
    if ([[uiChanges objectForKey:kRefreshRoommatesKey] boolValue] == YES)
    {
#warning this is the entry point. Idealy here we only update the information we have to. This will mean sending more information along with the resync dictionary.
        if (true) {
            for (UIView *view in [[self roommateImageSubviewContainer]subviews]) {
                [view removeFromSuperview];
            }
            roommateView = [RoommateImageSubview initRoommateImageSubview];
            [[self roommateImageSubviewContainer] addSubview:roommateView];
        }
        else
        {
            
        }
    }
}

@end

