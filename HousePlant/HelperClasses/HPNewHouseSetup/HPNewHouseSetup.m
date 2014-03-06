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
#warning there should be a nil check here on the house.
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:roommatesSyncRequest], @"syncRequestKey", [PFUser currentUser].objectId, @"src_usr",  nil];
        [HPPushHelper sendNotificationWithData:dict toChannel:house.houseName];
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:house.houseName forKey:@"channels"];
        [currentInstallation saveInBackground];
        
    }];

}

@end
