//
//  HPListTableViewCell.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-03-17.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPListTableViewCell.h"

#define CLOSED_SLIDER_X 0
#define OPEN_SLIDER_X -93
#define HALFWAY_SLIDER_X (OPEN_SLIDER_X/2)

@implementation HPListTableViewCell
{
    HPMainViewController *mainTableViewController;
    AMPAvatarView *avatar2;
}


- (void)awakeFromNib
{
    // Initialization code
    _panGesture.delegate = self;
    _checked = false;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDeletePress:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.deleteButton addGestureRecognizer:singleTap];
    [self.deleteButton setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //If the gesture is more in the Y direction than X than don't handle pan, the user is probably trying to scroll a table.
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self];
        return fabs(translation.y) < fabs(translation.x);
    }
    return NO;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    [_fader setHidden:false];
    CGPoint translation = [recognizer translationInView:self];
    bool outOfBounds = false;
    //Are they trying to slide it too far in one direction? Return.
    if (_mainCellView.frame.origin.x >= CLOSED_SLIDER_X && translation.x > 0) {
        outOfBounds = true;
    }
    if (_mainCellView.frame.origin.x <= OPEN_SLIDER_X && translation.x < 0) {
        outOfBounds = true;
    }
    
    //Did they lift their thumb?
    //Did the user lift thumb?
    //Fully open of fully close the sliderView based on where the user left off.
    if (recognizer.state == UIGestureRecognizerStateEnded || outOfBounds)
    {
        if(_mainCellView.frame.origin.x <= HALFWAY_SLIDER_X)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [_mainCellView setFrame:CGRectMake(OPEN_SLIDER_X, _mainCellView.frame.origin.y, _mainCellView.frame.size.width, _mainCellView.frame.size.height)];
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                [_mainCellView setFrame:CGRectMake(CLOSED_SLIDER_X, _mainCellView.frame.origin.y, _mainCellView.frame.size.width, _mainCellView.frame.size.height)];
            } completion:^(BOOL finished) {
                //
                [_fader setHidden:true];
            }];
            
        }
    }
    
    if (_mainCellView.center.x + translation.x > 160) {
        _mainCellView.center = CGPointMake(160,
                                           _mainCellView.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        return;
    }
    if (_mainCellView.center.x + translation.x < 160 + OPEN_SLIDER_X ) {
        _mainCellView.center = CGPointMake(160 + OPEN_SLIDER_X,
                                           _mainCellView.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        return;
    }
    
    _mainCellView.center = CGPointMake(_mainCellView.center.x + translation.x,
                                       _mainCellView.center.y);


    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void) checkCellAndMove:(BOOL) move {
    
    if([self.listEntry completedByImage] != nil)
    {
        [_noProfilePicImage setHidden:YES];
        _avatar = [[AMPAvatarView alloc] initWithFrame:CGRectMake(20, 12, 31, 31)];
        
        [self.mainCellView addSubview:_avatar];
        [self.mainCellView sendSubviewToBack:_avatar];
        _avatar.image = [self.listEntry completedByImage];
        
        [_avatar setBorderWith:0.0];
        [_avatar setShadowRadius:0.0];
        [_avatar setBorderColor:kLightBlueColour];
        
    }
    else
    {
        [_avatar setHidden:YES];
        [_noProfilePicImage setHidden:NO];
    }
    [_blankCheckbox setHidden:true];
    
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:_entryTitle.text attributes:attributes];
    _entryTitle.attributedText = attrText;

    
    _checked = true;
    
    if(move) {
        [self->mainTableViewController checkCell:self];
    }
}

- (void) uncheckCellAndMove:(BOOL) move {
    [_blankCheckbox setHidden:false];

    [_avatar setHidden:true];
    [_noProfilePicImage setHidden:YES];
    
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]
                                 };
    
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:_entryTitle.text attributes:attributes];
    _entryTitle.attributedText = attrText;
    
    _checked = false;
    
    if(move){
        [self->mainTableViewController uncheckCell:self];
    }
}

- (IBAction)onDeletePress:(id)sender {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"You sure?" message:@"Are you sure you want to remove this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yup", nil];
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [self->mainTableViewController removeCell:self];
    }
}

- (IBAction)onCheckboxPress:(id)sender {

    if (self.checked) {
        [self.listEntry setCompletedByName:nil];
        [self.listEntry setCompletedByImage:nil];
        self.listEntry.dateCompleted = nil;
        [avatar2 setHidden:YES];
        [self uncheckCellAndMove:YES];
        [self.listEntry setCompletedBy:nil];
    }
    else
    {

        [self.listEntry setCompletedBy:[HPCentralData getCurrentUser]];
        [self.listEntry setCompletedByName:self.listEntry.completedBy.username];
        self.listEntry.completedByImage = self.listEntry.completedBy.profilePic;
        self.listEntry.dateCompleted = [[NSDate alloc] init];
        [self checkCellAndMove:YES];
    }
    [self setText];
    [HPCentralData saveToDoListEntryWithSingleEntryLocalAndRemote:self.listEntry];
}

- (void) setText {
    if ([self.listEntry completedByName]) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:self.listEntry.dateCompleted
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        NSString *timeString = [NSDateFormatter localizedStringFromDate:self.listEntry.dateCompleted
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        self.entryDate.text = [NSString stringWithFormat:@"%@ at", dateString ];
        self.entryTime.text = timeString;
        _entryAddedName.text = @"Completed";
        CGRect frame = self.entryDate.frame;
        frame.origin.x = 110;
        self.entryDate.frame = frame;
        frame = self.entryTime.frame;
        frame.origin.x = 195;
        self.entryTime.frame =frame;
    } else {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:self.listEntry.dateAdded
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        NSString *timeString = [NSDateFormatter localizedStringFromDate:self.listEntry.dateAdded
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        self.entryDate.text = [NSString stringWithFormat:@"%@ at", dateString ];
        self.entryTime.text = timeString;
        _entryAddedName.text = @"Added";
        CGRect frame = self.entryDate.frame;
        frame.origin.x = 90;
        self.entryDate.frame = frame;
        frame = self.entryTime.frame;
        frame.origin.x = 175;
        self.entryTime.frame =frame;
    }
    [self layoutSubviews];
}

- (void) initWithListEntry:(HPListEntry *) entry andTableView:(HPMainViewController *) tableViewController
{
    self.listEntry = entry;
    self->mainTableViewController = tableViewController;
    self.entryTitle.text = entry.description;
    
    [self setText];
    if ([entry completedByName]) {
        [self checkCellAndMove:NO];
    } else {
        [self uncheckCellAndMove:NO];
    }
    
}
@end
