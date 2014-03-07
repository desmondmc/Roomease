//
//  SingleRoommateSubview.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/16/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "SingleRoommateSubview.h"

#import <AMPAvatarView/AMPAvatarView.h>

@implementation SingleRoommateSubview

+ (id)initSingleRoommateSubviewWithRoommate:(HPRoommate *)roommate
{
    SingleRoommateSubview *subView = [[[NSBundle mainBundle] loadNibNamed:@"SingleRoommateSubview" owner:nil options:nil] lastObject];
    
    
    if (roommate.profilePic) {
        AMPAvatarView *avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(11, 1, 59, 59)];
        [subView addSubview:avatar2];
        avatar2.image = roommate.profilePic;
        
        [subView sendSubviewToBack:avatar2];
        
        [avatar2 setBorderWith:0.0];
        [avatar2 setShadowRadius:0.0];
        [avatar2 setBorderColor:kLightBlueColour];
        
        [subView.profilePic setHidden:YES];
    }
    else
    {
        [subView.profilePic setHidden:NO];
    }
    
    
    subView.nameLabel.text = roommate.username;
    if ([roommate atHomeString]) {
        if ([[roommate atHomeString] isEqualToString:@"true"])
        {
            [subView.atHomeTint setHidden:true];
            [subView.unknownLocationImage setHidden: true];
        }
        
        else if ([[roommate atHomeString] isEqualToString:@"false"])
        {
            [subView.atHomeTint setHidden:false];
            [subView.unknownLocationImage setHidden: true];
        }
        
        else if ([[roommate atHomeString] isEqualToString:@"unknown"])
        {
            [subView.atHomeTint setHidden:true];
            [subView.unknownLocationImage setHidden: false];
        }
    }
    else //location is undefined
    {
        [subView.unknownLocationImage setHidden: false];
    }

    // make sure RoommateImageSubview is not nil or the wrong class!
    
    if ([subView isKindOfClass:[SingleRoommateSubview class]])
        return subView;
    else
        return nil;
}

@end