//
//  HPListTableViewCell.h
//  RoomEase
//
//  Created by Desmond McNamee on 2014-03-17.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AMPAvatarView/AMPAvatarView.h>
#import "HPMainViewController.h"

@interface HPListTableViewCell : UITableViewCell <UIGestureRecognizerDelegate, UIAlertViewDelegate>
{

}
@property (weak, nonatomic) ListItem *listItem;

- (IBAction)onDeletePress:(id)sender;
- (void) initWithListItem:(ListItem *) entry andTableView:(HPMainViewController *) tableViewController;
@property (weak, nonatomic) IBOutlet UIImageView *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *mainCellView;
@property (weak, nonatomic) IBOutlet UILabel *entryTitle;
@property (weak, nonatomic) IBOutlet UILabel *entryAddedName;
@property (weak, nonatomic) IBOutlet UILabel *entryDate;
@property (weak, nonatomic) IBOutlet UILabel *entryTime;
@property (weak, nonatomic) IBOutlet UIImageView *fader;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
- (IBAction)onCheckboxPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *blankCheckbox;
@property (strong, nonatomic) IBOutlet AMPAvatarView *avatar;
@property bool checked;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *noProfilePicImage;

@end
