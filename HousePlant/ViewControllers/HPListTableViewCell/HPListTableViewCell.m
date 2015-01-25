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

- (void) checkCell {
    
    if(self.listItem.completedBy.profilePicture != nil)
    {
        [_noProfilePicImage setHidden:YES];
        _avatar = [[AMPAvatarView alloc] initWithFrame:CGRectMake(20, 12, 31, 31)];
        
        [self.mainCellView addSubview:_avatar];
        [self.mainCellView sendSubviewToBack:_avatar];
        _avatar.image = [UIImage imageWithData:self.listItem.completedBy.profilePicture];
        
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
}

- (void) uncheckCell {
    [_blankCheckbox setHidden:false];

    [_avatar setHidden:true];
    [_noProfilePicImage setHidden:YES];
    
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]
                                 };
    
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:_entryTitle.text attributes:attributes];
    _entryTitle.attributedText = attrText;
    
    _checked = false;
}

//This is programmatically tied to the delete button, that's why it looks disconnected.
- (IBAction)onDeletePress:(id)sender {
    NSIndexPath *indexPath = [(UITableView *)self.superview indexPathForCell: self];
    
    [self->mainTableViewController removeCell:self atIndexPath:indexPath];
}


- (IBAction)onCheckboxPress:(id)sender {

    if (self.checked) {
        self.listItem.completedBy = nil;
        self.listItem.completedByImage = nil;
        self.listItem.completedAt = 0;
        [avatar2 setHidden:YES];
        [self uncheckCell];
    }
    else
    {
        self.listItem.completedBy = [HPCentralData getCurrentUser];
        self.listItem.completedByImage = [UIImage imageWithData:self.listItem.completedBy.profilePicture];
        self.listItem.completedAt = [[[NSDate alloc] init] timeIntervalSince1970];
        [self checkCell];
    }
    [self setText];
}

- (void) setText {
    if (self.listItem.completedBy) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:
                                [NSDate dateWithTimeIntervalSince1970:self.listItem.completedAt]
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        
        NSString *timeString = [NSDateFormatter localizedStringFromDate:
                                [NSDate dateWithTimeIntervalSince1970:self.listItem.completedAt]
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
        NSString *dateString = [NSDateFormatter localizedStringFromDate:
                                [NSDate dateWithTimeIntervalSince1970:self.listItem.createdAt]
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        NSString *timeString = [NSDateFormatter localizedStringFromDate:
                                [NSDate dateWithTimeIntervalSince1970:self.listItem.createdAt]
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

- (void) initWithListItem:(ListItem *) entry andTableView:(HPMainViewController *) tableViewController andIndexPath:(NSIndexPath *)indexPath
{
    self.listItem = entry;
    self.entryTitle.text = entry.name;
    
    NSString *createdAtString = [NSString stringWithFormat:@"%@ at", [NSDateFormatter localizedStringFromDate:
                                                                      [NSDate dateWithTimeIntervalSince1970:entry.createdAt]
                                                                                                    dateStyle:NSDateFormatterMediumStyle
                                                                                                    timeStyle:NSDateFormatterNoStyle]];
    
    self.entryDate.text = createdAtString;
    
    self.entryTime.text = [NSDateFormatter localizedStringFromDate:
                           [NSDate dateWithTimeIntervalSince1970:entry.createdAt]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    
    self->mainTableViewController = tableViewController;
    
    self.cellIndexPath = indexPath;
    
    
    
//    self.listItem = entry;
//    self->mainTableViewController = tableViewController;
//    self.entryTitle.text = entry.name;
//    
//    [self setText];
//    if (entry.completedBy) {
//        [self checkCell];
//    } else {
//        [self uncheckCell];
//    }
}
@end
