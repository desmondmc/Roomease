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

+(void) resyncAllData
{
    //resync everything stored in NSUserDefault store with fresh parse data! Yum :)
}

+(void) resyncCurrentUser
{
    //resync all the current user info.
}

+(void) resyncHouse
{
    //resync this users house.
}

+(void) resyncRoommates
{
    //resync the roommates in this house.
}

+(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block
{
    //if the user isn't stored in NSUserDefaults pull him from parse. Otherwise return the user stored in NSUserDefaults. Do this on a background thread.
}

+(void) clearCentralData
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        NSLog(@"Key: %@", key);
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+(HPRoommate *) getCurrentUser;
{
    //if the user isn't stored in NSUserDefaults pull him from parse. Otherwise return the user stored in NSUserDefaults.
    
    NSData *roommateData = [persistantStore objectForKey:@"hp_currentUser"];
    HPRoommate *roommate =  [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
    
    if(roommate == nil)
    {
        roommate = [[HPRoommate alloc] init];
        PFUser * currentUser = (PFUser *)[PFUser currentUser].fetchIfNeeded;
        roommate.username = [currentUser username];
        roommate.atHome = [currentUser[@"atHome"] boolValue];
       
        PFFile *userImageFile = [currentUser objectForKey:@"profilePic"];
        roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
        
        //convert roommate object into encoded data to store in NSUserdefault
        roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
        
        [persistantStore setObject:roommateData forKey:@"hp_currentUser"];
        [persistantStore synchronize];
    }
    
    return roommate;
}

+(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block
{
    __block NSData  *homeData = [persistantStore objectForKey:@"@hp_home"];
    __block HPHouse *home = [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    
    if (home == nil)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

            home = [[HPHouse alloc] init];
            [[PFUser currentUser] fetch];
            PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
            if (parseHome == nil)
            {
                //No home exists for this user yet.
                if (block)
                    block(nil, nil);
                return;
            }
            parseHome = parseHome.fetchIfNeeded;
            home.houseName = [parseHome objectForKey:@"name"];
            home.location = [parseHome objectForKey:@"location"];
            
            
            //convert roommate object into encoded data to store in NSUserdefault
            homeData = [NSKeyedArchiver archivedDataWithRootObject:home];
            [persistantStore setObject:homeData forKey:@"hp_home"];
            [persistantStore synchronize];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(home, nil);
            });
        });
    }
    else if (block)
    {
        block(home, nil);
    }
        
}

+(HPHouse *) getHouse
{
    NSData *homeData = [persistantStore objectForKey:@"hp_home"];
    HPHouse *home =  [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    
    if (home == nil) {
        home = [[HPHouse alloc] init];
        [[PFUser currentUser] fetch];
        PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
        if (parseHome == nil)
        {
            //No home exists for this user yet.
            return nil;
        }
        parseHome = parseHome.fetchIfNeeded;
        home.houseName = [parseHome objectForKey:@"name"];
        home.location = [parseHome objectForKey:@"location"];
        
        
        //convert roommate object into encoded data to store in NSUserdefault
        homeData = [NSKeyedArchiver archivedDataWithRootObject:home];
        [persistantStore setObject:homeData forKey:@"hp_home"];
        [persistantStore synchronize];
    }
    return home;
}

+(void) saveHouseInBackgroundWithHouse:(HPHouse *)house andBlock:(CentralDataSaveResultBlock)block
{

}

+(void) saveHouse:(HPHouse *)house
{

}

+(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block
{

}

+(NSArray *) getRoommates
{
    return nil;
}

@end
