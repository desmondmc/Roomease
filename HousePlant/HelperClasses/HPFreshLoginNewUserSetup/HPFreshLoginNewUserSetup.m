//
//  HPFreshLoginNewUserSetup.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-03-25.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPFreshLoginNewUserSetup.h"

@implementation HPFreshLoginNewUserSetup

+(void)setupAfterFreshLogin
{
    //If this is a new user and their first time logging in.
    if ([HPCentralData getStateFirstTimeLoginAndSetToFalse] == true)
    {
        //Setup channels. Subscribe them to every channel this can't be done.
    }
}

@end
