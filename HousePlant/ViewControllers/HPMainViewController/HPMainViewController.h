//
//  HPMainViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/28/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HPUINotifierDelegate.h"
#import "HPToDoListTableView.h"


@interface HPMainViewController : UIViewController <HPUINotifierDelegate,  UIAlertViewDelegate, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *roommateImageSubviewContainer;
@property (strong, nonatomic) IBOutlet HPToDoListTableView *toDoListTableView;

- (void) removeCell:(id) cell;
- (void) checkCell:(id) cell;
- (void) uncheckCell:(id) cell;
- (IBAction)onSettingsPress:(id)sender;
- (IBAction)onAddListEntryPress:(id)sender;



@end
