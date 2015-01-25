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
    
    [self.toDoListTableView registerNib:[UINib nibWithNibName:@"HPListTableViewCell" bundle:nil] forCellReuseIdentifier:@"hpListTableViewCell"];
    
    [HPSyncWorker handleSyncRequestWithType:todoListSyncRequest andData:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationAppActive:)
                                                 name:NOTIFICATION_APP_BECAME_ACTIVE
                                               object:nil];
    
    self->refreshControl = [[ISRefreshControl alloc] init];
    [self->refreshControl setTintColor:[UIColor colorWithRed:218.0/255.0 green:240.0/255.0 blue:254.0/251.0 alpha:1]];
    [_toDoListTableView addSubview:refreshControl];
    
    [[self fetchedResultsController] performFetch:nil];
    
    
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
    
    [HPCentralData refreshAllListEntriesFromCloudInBackgroundWithBlock:nil];
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

- (void) removeCell:(HPListTableViewCell *) cell atIndexPath:(NSIndexPath *)indexPath
{
    [HPCentralData deleteToDoListEntryWithCell:indexPath andFetchedResultsController:[self fetchedResultsController]];
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
    
    [HPCentralData refreshAllListEntriesFromCloudInBackgroundWithBlock:^(NSError *error) {
        [self->refreshControl endRefreshing];
    }];
    
    
    
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
    HPListTableViewCell *cell = nil;
    
    cell = (HPListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        //There was no reusablecell to dequeue
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    
    ListItem *toDoListItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell initWithListItem:toDoListItem andTableView:self andIndexPath:indexPath];

    
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0) //Delete was pressed.
    {
        NSLog(@"Delete button was pressed");
        // Delete button was pressed
        NSIndexPath *cellIndexPath = [self.toDoListTableView indexPathForCell:cell];
        [HPCentralData deleteToDoListEntryWithCell:cellIndexPath andFetchedResultsController:[self fetchedResultsController]];
    }
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return true;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    UIColor *deleteButtonColor = [UIColor colorWithRed:241/255.0f green:107/255.0f blue:107/255.0f alpha:1.0f];

    [rightUtilityButtons sw_addUtilityButtonWithColor:deleteButtonColor title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSFetchRequest *) toDoListFetchRequest
{
    return [HPCentralData getAllToDoListEntriesFetchRequest];
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

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.toDoListTableView beginUpdates];
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            
            [self.toDoListTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [self.toDoListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            [self.toDoListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            
            [self.toDoListTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [self.toDoListTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.toDoListTableView endUpdates];
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

