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
#import "NPReachability.h"
#import "RoommateImageSubview.h"
#import "HPSettingsViewController.h"
#import "HPUINotifier.h"
#import "HPListTableViewCell.h"
#import "ISRefreshControl.h"

@interface HPMainViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

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
    [self->refreshControl setTintColor:[UIColor colorWithRed:218.0/255.0 green:240.0/255.0 blue:254.0/251.0 alpha:1]];
    
    
    [[self fetchedResultsController] performFetch:nil];
    [_toDoListTableView addSubview:refreshControl];
    
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
    
}

- (void) checkCell:(HPListTableViewCell *) cell
{
    
}
- (void) uncheckCell:(HPListTableViewCell *) cell
{
    
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
        
        [HPCentralData saveNewToDoListEntryWithName:[alertView textFieldAtIndex:0].text];
        
        [HPSyncWorker handleSyncRequestWithType:todoListSyncRequest andData:nil];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =  [[self fetchedResultsController] sections][section];
    
    return [sectionInfo numberOfObjects];
}

- (NSInteger)tableView:(NSInteger)numberOfSections
{
    return [self fetchedResultsController].sections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"hpListTableViewCell";
    HPListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        //There was no reusablecell to dequeue
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    ListItem *toDoListItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.entryTitle.text = toDoListItem.name;
    
    cell.entryDate.text = [NSDateFormatter localizedStringFromDate:
                           [NSDate dateWithTimeIntervalSince1970:toDoListItem.createdAt]
                                                         dateStyle:NSDateFormatterMediumStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    
    cell.entryTime.text = [NSDateFormatter localizedStringFromDate:
                           [NSDate dateWithTimeIntervalSince1970:toDoListItem.createdAt]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    
    return cell;
}

- (NSFetchRequest *) toDoListFetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDListItem"];
    
    //This sort descripor should arrange entries with uncompleted at the top and completed at the bottom and then sort by their created date.
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isComplete" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    
    return fetchRequest;
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self toDoListFetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.toDoListTableView reloadData];
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
    }
}

- (int) countChecked {
    int numberOfCheckedCells = 0;
    for (ListItem *entry in listItems) {
        if(entry.completedBy)
            numberOfCheckedCells++;
    }
    return numberOfCheckedCells;
}

@end

