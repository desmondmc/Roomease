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


+(void) clearCentralData
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block
{

    __block NSData *roommateData = [persistantStore objectForKey:@"hp_currentUser"];
    __block HPRoommate *roommate =  [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
    
    if(roommate == nil)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            roommate = [[HPRoommate alloc] init];
            [[PFUser currentUser] fetch];
            roommate.username = [[PFUser currentUser] username];
            roommate.atHome = [[PFUser currentUser][@"atHome"] boolValue];
        
            PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profilePic"];
            roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
        
            //convert roommate object into encoded data to store in NSUserdefault
            roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
        
            [persistantStore setObject:roommateData forKey:@"hp_currentUser"];
            [persistantStore synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(roommate, nil);
            });
        });
    }

    if (block)
        block(roommate, nil);
    
}


+(HPRoommate *) getCurrentUser;
{
    //if the user isn't stored in NSUserDefaults pull him from parse. Otherwise return the user stored in NSUserDefaults.
    
    NSData *roommateData = [persistantStore objectForKey:@"hp_currentUser"];
    HPRoommate *roommate =  [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
    
    if(roommate == nil)
    {
        roommate = [[HPRoommate alloc] init];
        [[PFUser currentUser] fetch];
        roommate.username = [[PFUser currentUser] username];
        roommate.atHome = [[PFUser currentUser][@"atHome"] boolValue];
       
        PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profilePic"];
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
    __block NSData  *homeData = [persistantStore objectForKey:@"hp_home"];
    __block HPHouse *home = [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    
    if (home == nil)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            home = [[HPHouse alloc] init];
            [[PFUser currentUser] fetch];
            __block PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
            if (parseHome == nil)
            {
                //No home exists for this user yet.
                if (block)
                    block(nil, nil);
                return;
            }
            parseHome = [parseHome fetchIfNeeded];
            home.houseName = [parseHome objectForKey:@"name"];
            home.location = [parseHome objectForKey:@"location"];
            home.addressText = [parseHome objectForKey:@"addressText"];
            
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
        //No local copy yet. Better grab it from parse.
        home = [[HPHouse alloc] init];
        [[PFUser currentUser] fetch];
        __block PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
        
        [parseHome fetch];
        if (parseHome == nil)
        {
            //No home exists for this user yet.
            return nil;
        }
        home.houseName = [parseHome objectForKey:@"name"];
        home.location = [parseHome objectForKey:@"location"];
        home.addressText = [parseHome objectForKey:@"addressText"];
        
        //convert roommate object into encoded data to store in NSUserdefault
        homeData = [NSKeyedArchiver archivedDataWithRootObject:home];
        [persistantStore setObject:homeData forKey:@"hp_home"];
        [persistantStore synchronize];
    }
    return home;
}

+ (void) saveHouseInBackgroundWithHouse:(HPHouse *)house andBlock:(CentralDataSaveResultBlock)block
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        HPHouse *oldHouse = [HPCentralData getHouse];
        HPHouse *newHouse = house;
        __block NSError *error = nil;
        
        //save the new house to parse.
        [[PFUser currentUser] fetch];
        PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
        if (parseHome == nil)
        {
            //this should never happen
            NSLog(@"User house is null on the server. This should never happen.");
            if (block)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"save failed" forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"house" code:100 userInfo:details];
                block(error);
            }
            return;
        }
        
        //Set the new attributes as long as they are not null. If they are null we assume keep the old NSUserDefault values.
        bool parseSave = [HPCentralData transferAttributesFromHouse:house toPFObject:parseHome];
        
        if (parseSave == false) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"save failed" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"house" code:200 userInfo:details];
        }
        
        newHouse = [HPCentralData transferOldhouse:oldHouse toNewHouse:newHouse];
        
        //if it is successfully saved to parse, replace the hp_home in NSUserDefaults with the new house.
        //convert roommate object into encoded data to store in NSUserdefault
        NSData *homeData = [NSKeyedArchiver archivedDataWithRootObject:newHouse];
        [persistantStore setObject:homeData forKey:@"hp_home"];
        [persistantStore synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(error);
                
        });
    });
}

+ (bool) saveHouse:(HPHouse *)house
{
    //save the new house to parse.
    PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
    HPHouse *oldHouse = [HPCentralData getHouse];
    
    if (parseHome == nil)
    {
        //this should never happen
        NSLog(@"User house is null on the server. This should never happen.");
        return false;
    }
 
    //Set the new attributes as long as they are not null. If they are null we assume keep the old NSUserDefault values.
    [HPCentralData transferAttributesFromHouse:house toPFObject:parseHome];
    house = [HPCentralData transferOldhouse:oldHouse toNewHouse:house];
    
    //if it is successfully saved to parse, replace the hp_home in NSUserDefaults with the new house.
    //convert roommate object into encoded data to store in NSUserdefault
    NSData *homeData = [NSKeyedArchiver archivedDataWithRootObject:house];
    [persistantStore setObject:homeData forKey:@"hp_home"];
    [persistantStore synchronize];
    
    return true;
}

+(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block
{
  
}

+(NSArray *) getRoommates
{
    NSMutableArray *roommatesData = [persistantStore objectForKey:@"hp_roommates"];
    NSMutableArray *roommates = [[NSMutableArray alloc] init];
    
    for (NSData *roommateData in roommatesData) {
        HPRoommate *roommate = [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
        [roommates addObject:roommate];
    }
    
    if ([roommates count] == 0)
    {
        roommatesData = [[NSMutableArray alloc] init];
        
        //pulling from parse
        [[PFUser currentUser] fetch];
        __block PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
        
        [parseHome fetch];
        if (parseHome == nil)
        {
            //No home exists for this user yet.
            return nil;
        }

        NSArray *pfRoommates = [parseHome objectForKey:@"users"];
        for (PFObject *pfRoommate in pfRoommates) {
            [pfRoommate fetch];
            HPRoommate * roommate = [[HPRoommate alloc] init];
            roommate.username = pfRoommate[@"username"];
            roommate.atHome = [pfRoommate[@"atHome"] boolValue];
            
            PFFile *userImageFile = [pfRoommate objectForKey:@"profilePic"];
            roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
            
            [roommates addObject:roommate];
            
            NSData *roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
            [roommatesData addObject:roommateData];
        }
        
        [persistantStore setObject:roommatesData forKey:@"hp_roommates"];
        [persistantStore synchronize];
        
    }
    
    return roommates;
}

#pragma mark - Helper Methods

+ (bool)transferAttributesFromHouse:(HPHouse *)house toPFObject:(PFObject *)parseHome
{
    //Set the new attributes as long as they are not null. If they are null we assume keep the old NSUserDefault values.
    if ([house houseName] != nil) {
        parseHome[@"name"] = [house houseName];
    }
    
    if ([house location] != nil) {
        parseHome[@"location"] =  [PFGeoPoint geoPointWithLocation:[house location]];
    }
    
    if ([house addressText] != nil) {
        parseHome[@"addressText"] = [house addressText];
    }
    
    if ([parseHome save] == false) {
        return false;
    }
    
    return true;
}

//This function fills in any blankspaces in the new house with the old houses attributes. This prevents blanks being stored in local storage.
+ (HPHouse *) transferOldhouse:(HPHouse *)oldHouse toNewHouse:(HPHouse *)newHouse
{
    //Set the new attributes as long as they are not null. If they are null we assume keep the old NSUserDefault values.
    if ([newHouse houseName] == nil) {
        newHouse.houseName = oldHouse.houseName;
    }
    
    if ([newHouse location] == nil) {
        newHouse.location = oldHouse.location;
    }
    
    if ([newHouse addressText] == nil) {
        newHouse.addressText = oldHouse.addressText;
    }
    
    if ([newHouse region] == nil) {
        newHouse.region = oldHouse.region;
    }
    
    return newHouse;
}

@end
