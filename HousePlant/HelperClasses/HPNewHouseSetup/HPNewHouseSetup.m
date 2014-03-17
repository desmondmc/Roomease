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
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObjectsFromArray:@[house.houseName, [PFUser currentUser].username] forKey:@"channels"];
        [currentInstallation saveInBackground];
        
    }];

}

@end
