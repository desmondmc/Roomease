//
//  HPNewHouseSetup.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/16/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPNewHouseSetup.h"

@implementation HPNewHouseSetup

//Called when a user enters a house for the first time. Sorry bad naming.
+(void) setup
{
    // Subscribe to channel of house name.
    
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
#warning there should be a nil check here on the house. Cloud code could potentially fail.
        [HPPushHelper sendNotificationWithData:nil toChannel:[house houseName] andAlert:[NSString stringWithFormat:@"%@ joined the house!!", [[PFUser currentUser] username]]];
        
        //This needs to be done when a house is created because the is the first time the new user has both a house and a username.
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObjectsFromArray:@[house.houseName] forKey:@"channels"];
        [currentInstallation saveInBackground];
        
    }];

}

@end
