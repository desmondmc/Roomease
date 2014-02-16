//
//  SingleRoommateSubview.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/16/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "SingleRoommateSubview.h"

@implementation SingleRoommateSubview

+ (id)initSingleRoommateSubviewWithRoommate:(HPRoommate *)roommate
{
    SingleRoommateSubview *subView = [[[NSBundle mainBundle] loadNibNamed:@"SingleRoommateSubview" owner:nil options:nil] lastObject];
    
    
    //subView.profilePic = roommate.profilePic;
    subView.nameLabel.text = roommate.username;
    
    // make sure RoommateImageSubview is not nil or the wrong class!
    
    if ([subView isKindOfClass:[SingleRoommateSubview class]])
        return subView;
    else
        return nil;
}

@end
