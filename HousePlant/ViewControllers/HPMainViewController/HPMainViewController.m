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
#import "ISRefreshControl.h"

@interface HPMainViewController ()

@end

@implementation HPMainViewController
{
    RoommateImageSubview *roommateView;
    NSMutableArray *listItems;
    ISRefreshControl *refreshControl;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tableViewDataSource = [[HPToDoListDataSource alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [HPSyncWorker handleSyncRequestWithType:todoListSyncRequest andData:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationAppActive:)
                                                 name:NOTIFICATION_APP_BECAME_ACTIVE
                                               object:nil];
    
    self->refreshControl = [[ISRefreshControl alloc] init];
//    [self->refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Refreshing..." attributes:nil]];
    [self->refreshControl setTintColor:[UIColor blueColor]];
    [self.todoListTableView addSubview:refreshControl];
    
    [self->refreshControl addTarget:self
                       action:@selector(onRefreshRmPress:)
             forControlEvents:UIControlEventValueChanged];
    
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
    [self countChecked];
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
//    [HPCentralData getCurrentUserInBackgroundWithBlock:^(HPRoommate *roommate, NSError *error) {
//        
//        if ([[roommate atHomeString] isEqualToString:@"false"]) {
//            [roommate setAtHomeString:@"true"];
//        }
//        else
//        {
//            [roommate setAtHomeString:@"false"];
//        }
//        
//        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
//    }];
    
//    HPListEntry *newListEntry = [[HPListEntry alloc] init];
//    newListEntry.description = @"test entry";
//    [HPCentralData saveToDoListEntryWithSingleEntry:newListEntry];
    
    NSDictionary *notifierDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"CeQn49plm8", @"objectId", nil];
    [HPSyncWorker handleSyncRequestWithType:todoListSyncRequest andData:notifierDictionary];
    
}

- (void) removeCell:(HPListTableViewCell *) cell
{
    [self.todoListTableView beginUpdates];
    [self.todoListTableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[self.todoListTableView indexPathForCell:cell], nil]  withRowAnimation:UITableViewRowAnimationFade];
    [HPCentralData removeToDoListEntryWithSingleEntryLocalAndRemote:cell.listEntry];
    [self.todoListTableView endUpdates];
}

- (void) checkCell:(HPListTableViewCell *) cell
{
    [self countChecked];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([self.todoListTableView numberOfRowsInSection:0] - 1) inSection:0];
    
    [self.todoListTableView beginUpdates];
    [self.todoListTableView moveRowAtIndexPath:[self.todoListTableView indexPathForCell:cell] toIndexPath:lastIndexPath];
    [self.todoListTableView endUpdates];
}
- (void) uncheckCell:(HPListTableViewCell *) cell
{
    int numberOfCheckedCells = [self countChecked] + 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([self.todoListTableView numberOfRowsInSection:0] - (numberOfCheckedCells)) inSection:0];
    
    [self.todoListTableView beginUpdates];
    [self.todoListTableView moveRowAtIndexPath:[self.todoListTableView indexPathForCell:cell] toIndexPath:lastIndexPath];
    [self.todoListTableView endUpdates];
}


- (IBAction)onSettingsPress:(id)sender {
    HPSettingsViewController *settingsViewController = [[HPSettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // initialize the navigation controller and present it
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

- (IBAction)onRefreshRmPress:(id)sender {
    //Starts a sync request. Will be called back on resyncUIWithDictionary.
    [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest andData:nil];
    [HPSyncWorker handleSyncRequestWithType:todoListSyncRequest andData:nil];
    [self->refreshControl endRefreshing];
}

- (IBAction)onAddListEntryPress:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add a List Item" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //If the user hits ok.
    if (buttonIndex == 1) {
        //Save entry to parse.
        
        HPListEntry *listEntry = [[HPListEntry alloc] init];
        
        listEntry.description2 = [alertView textFieldAtIndex:0].text;
        listEntry.dateAdded = [NSDate date];
        
        [HPCentralData saveToDoListEntryWithSingleEntryLocalAndRemote:listEntry];
        
        [HPSyncWorker handleSyncRequestWithType:todoListSyncRequest andData:nil];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[NSMutableArray arrayWithArray:[HPCentralData getToDoListEntriesAndForceReloadFromParse:NO]] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!listItems) {
        listItems = [NSMutableArray arrayWithArray:[HPCentralData getToDoListEntriesAndForceReloadFromParse:NO]];
    }
    HPListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hpListTableViewCell"];
    
    if (cell == nil) {
        //There was no reusablecell to dequeue
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HPListEntry *entry = [listItems objectAtIndex:indexPath.row];
    [cell initWithListEntry:entry andTableView:self];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Notification Handlers

- (void) receiveNotificationAppActive:(NSNotification *) notification
{
    [[HPLocationManager sharedLocationManager] updateAtHomeStatus];
}

#pragma mark - HPUINotifierDelegate

-(void) resyncUIWithDictionary:(NSDictionary *)uiChanges
{
    if ([uiChanges objectForKey:kRefreshTodoListKey] != nil)
    {
        listItems = [NSMutableArray arrayWithArray:[HPCentralData getToDoListEntriesAndForceReloadFromParse:NO]];
        [self countChecked];
        
        [[self todoListTableView] reloadData];
        
    }
}

- (int) countChecked {
    int numberOfCheckedCells = 0;
    for (HPListEntry *entry in listItems) {
        if(entry.completedByName)
            numberOfCheckedCells++;
    }
    return numberOfCheckedCells;
}

@end

