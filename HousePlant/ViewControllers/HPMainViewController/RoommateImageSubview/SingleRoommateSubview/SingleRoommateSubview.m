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
    
    [subView refreshSingleRoomateSubview:roommate];
    
    // make sure RoommateImageSubview is not nil or the wrong class!
    
    if ([subView isKindOfClass:[SingleRoommateSubview class]])
        return subView;
    else
        return nil;
}

- (void) refreshSingleRoomateSubview:(HPRoommate *)roommate
{
    if (roommate.profilePic) {
        AMPAvatarView *avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(11, 1, 65, 65)];
        [self addSubview:avatar2];
        avatar2.image = roommate.profilePic;
        
        [self sendSubviewToBack:avatar2];
        
        [avatar2 setBorderWith:0.0];
        [avatar2 setShadowRadius:0.0];
        [avatar2 setBorderColor:kLightBlueColour];
        
        [self.profilePic setHidden:YES];
    }
    else
    {
        [self.profilePic setHidden:NO];
    }
    
    
    self.nameLabel.text = roommate.username;
    if ([roommate atHomeString]) {
        if ([[roommate atHomeString] isEqualToString:@"true"])
        {
            [self.atHomeTint setHidden:true];
            [self.unknownLocationImage setHidden: true];
        }
        
        else if ([[roommate atHomeString] isEqualToString:@"false"])
        {
            [self.atHomeTint setHidden:false];
            [self.unknownLocationImage setHidden: true];
        }
        
        else if ([[roommate atHomeString] isEqualToString:@"unknown"])
        {
            [self.atHomeTint setHidden:true];
            [self.unknownLocationImage setHidden: false];
        }
    }
    else //location is undefined
    {
        [self.unknownLocationImage setHidden: false];
    }

}

- (IBAction)onViewPress:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Settings" message:@"Do you want to recieve notifications from this user when they leave/arrive home?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger) buttonIndex{
    
    if (buttonIndex == 1) {
        // Yes
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:_nameLabel.text forKey:@"channels"];
        [currentInstallation saveEventually];
    } else {
        // No
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation removeObject:_nameLabel.text forKey:@"channels"];
        [currentInstallation saveEventually];
    }
}

@end
