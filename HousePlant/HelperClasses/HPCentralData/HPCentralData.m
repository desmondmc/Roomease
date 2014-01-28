//
//  HPCentralData.m
//  RoomEase
//
//  Created by Desmond McNamee on 1/9/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPCentralData.h"

#define persistantStore [NSUserDefaults standardUserDefaults]

@implementation HPCentralData

-(void) resyncAllData
{
    //resync everything stored in NSUserDefault store with fresh parse data! Yum :)
}

-(void) resyncCurrentUser
{
    //resync all the current user info.
}

-(void) resyncHouse
{
    //resync this users house.
}

-(void) resyncRoommates
{
    //resync the roommates in this house.
}

-(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block
{
    //if the user isn't stored in NSUserDefaults pull him from parse. Otherwise return the user stored in NSUserDefaults. Do this on a background thread.
}

-(HPRoommate *) getCurrentUser;
{
    //if the user isn't stored in NSUserDefaults pull him from parse. Otherwise return the user stored in NSUserDefaults.
    
    HPRoommate *roommate = [persistantStore objectForKey:@"currentUser"];
    if(roommate == nil)
    {
        roommate = [[HPRoommate alloc] init];
        PFUser * currentUser = (PFUser *)[PFUser currentUser].fetchIfNeeded;
        roommate.username = [currentUser username];
        roommate.atHome = [currentUser[@"atHome"] boolValue];
       
        PFFile *userImageFile = [currentUser objectForKey:@"profilePic"];
        roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
    }
    
    return roommate;
}

-(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block
{

}

-(HPHouse *) getHouse
{
    return nil;
}

-(void) saveHouseInBackgroundWithHouse:(HPHouse *)house andBlock:(CentralDataSaveResultBlock)block
{

}
-(void) saveHouse:(HPHouse *)house
{

}

-(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block
{

}
-(NSArray *) getRoommates
{
    return nil;
}

@end
