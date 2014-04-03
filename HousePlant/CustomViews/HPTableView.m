//
//  HPTableView.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-03.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPTableView.h"
#import "HPListTableViewCell.h"

@implementation HPTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) checkCellWithCell:(HPListTableViewCell *)hpCell
{
    [HPCentralData getCurrentUserInBackgroundWithBlock:^(HPRoommate *roommate, NSError *error) {
        //
        if([roommate profilePic])
        {
            hpCell.avatar = [[AMPAvatarView alloc] initWithFrame:CGRectMake(20, 5, 31, 31)];
            
            [hpCell.mainCellView addSubview:hpCell.avatar];
            [hpCell.mainCellView sendSubviewToBack:hpCell.avatar];
            hpCell.avatar.image = roommate.profilePic;
            
            [hpCell.avatar setBorderWith:0.0];
            [hpCell.avatar setShadowRadius:0.0];
            [hpCell.avatar setBorderColor:kLightBlueColour];
            
            [hpCell.blankCheckbox setHidden:true];
            
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                         };
            
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:hpCell.entryTitle.text attributes:attributes];
            hpCell.entryTitle.attributedText = attrText;
        }
    }];
    
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:([self numberOfRowsInSection:0] - 1) inSection:0];
    
    [self moveRowAtIndexPath:[self indexPathForCell:hpCell] toIndexPath:lastIndexPath];
    hpCell.checked = true;
}

- (void) uncheckCellWithCell:(UITableViewCell *)cell
{

}

@end
