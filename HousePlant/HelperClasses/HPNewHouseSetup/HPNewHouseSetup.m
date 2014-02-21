//
//  HPNewHouseSetup.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/16/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPNewHouseSetup.h"

@implementation HPNewHouseSetup

+(void) setup
{
    // Subscribe to channel of house name.
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
#warning there should be a nil check here on the house.
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:house.houseName forKey:@"channels"];
        [currentInstallation saveInBackground];
    }];

}

@end
