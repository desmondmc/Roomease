//
//  HPCentralData.m
//  RoomEase
//
//  Created by Desmond McNamee on 1/9/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPCentralData.h"

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

+(void) resyncRoommates:(CentralDataSaveResultBlock)block
{
    //resync the roommates in this house.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSMutableArray *roommatesData = [[NSMutableArray alloc] init];
        
        //pulling from parse
        
        PFQuery *query = [PFQuery queryWithClassName:@"House"];
        [query includeKey:@"users"];
        
        PFObject *parseHome = [query getObjectWithId:[[[PFUser currentUser] objectForKey:@"home"] objectId]];
        if (parseHome == nil)
        {
            //No home exists for this user yet.
            if (block)
            {
                block(nil);
            }
        }
        
        NSArray *pfRoommates = [parseHome objectForKey:@"users"];
        for (PFObject *pfRoommate in pfRoommates) {
            
            HPRoommate * roommate = [[HPRoommate alloc] initWithPFObject:pfRoommate];
            
            NSData *roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
            [roommatesData addObject:roommateData];
        }
        
        [persistantStore setObject:roommatesData forKey:kPersistantStoreRoommates];
        [persistantStore synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(nil);
        });
        
        
    });
}

+(void) resyncEntryForId:(NSString *)objectId andList:(syncRequest_t)listId withBlock:(CentralDataSaveResultBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Entry"];
        PFObject *pfEntry = [query getObjectWithId:objectId];
        
        
        if (listId == todoListSyncRequest)
        {
            //[HPCentralData saveToDoListEntryWithSingleEntryLocal:listEntry];
        }
        else
        {
#warning fix this for multiple list handling
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(nil);
        });
    });
}


+(void) clearCentralData
{
    NSUserDefaults * defs = persistantStore;
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+(void) clearCoreData
{
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *entityDescription = @"CDListItem";
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [coreDataStack.managedObjectContext deleteObject:managedObject];
    }
    
    [coreDataStack saveContext];
}

+(void) clearLocalHouseData
{
    [persistantStore removeObjectForKey:kPersistantStoreHome];
    [persistantStore synchronize];
}

+(void) clearLocalRoommatesData
{
    [persistantStore removeObjectForKey:kPersistantStoreRoommates];
    [persistantStore synchronize];
}

+(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block
{

    __block NSData *roommateData = [persistantStore objectForKey:kPersistantStoreCurrentUser];
    __block HPRoommate *roommate =  [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
    
    if(roommate == nil)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            roommate = [[HPRoommate alloc] init];
            [[PFUser currentUser] fetch];
            roommate.username = [[PFUser currentUser] username];
            [roommate setAtHomeString:[PFUser currentUser][@"atHome"]];
        
            PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profilePic"];
            roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
        
            //convert roommate object into encoded data to store in NSUserdefault
            roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
        
            [persistantStore setObject:roommateData forKey:kPersistantStoreCurrentUser];
            [persistantStore synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(roommate, nil);
            });
        });
    }
    else if (block)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                block(roommate, nil);
            });
        });
    }
}


+(Roommate *) getCurrentUser;
{
    //if the user isn't stored in NSUserDefaults pull him from parse. Otherwise return the user stored in NSUserDefaults.
    
    NSData *roommateData = [persistantStore objectForKey:kPersistantStoreCurrentUser];
    HPRoommate *roommate =  [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
    
    if(roommate == nil || [roommate objectId] == nil)
    {
        roommate = [[HPRoommate alloc] init];
        [[PFUser currentUser] fetch];
        PFUser *currentUser = [PFUser currentUser];
        roommate.username = [[PFUser currentUser] username];
       
        PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"profilePic"];
        roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
        roommate.objectId = currentUser.objectId;
        [roommate setAtHomeString:currentUser[@"atHome"]];
        
        //convert roommate object into encoded data to store in NSUserdefault
        roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
        
        [persistantStore setObject:roommateData forKey:kPersistantStoreCurrentUser];
        [persistantStore synchronize];        
    }
    
    return roommate;
}

+(void) saveCurrentUserInBackgroundWithRoommate:(HPRoommate*)roommate andBlock:(CentralDataSaveResultBlock)block
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error;
        if (![HPCentralData saveCurrentUser:roommate])
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"save failed" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"house" code:100 userInfo:details];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(error);
        });
    });
}

+(bool) saveCurrentUser:(HPRoommate *)roommate
{
    //save the new user to parse.
    PFUser *currentUser = [PFUser currentUser];
    HPRoommate *oldUser = [HPCentralData getCurrentUser];
    
#warning does it makes sence to switch the order of the following two lines of code? That way roommate's nil fields will be filled with local storage values before sending the new roommate to parse.
    [HPCentralData transferAttributesFromUser:roommate toPFObject:currentUser];
    
    roommate = [HPCentralData transferOldRoommate:oldUser toNewRoomate:roommate];
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
    [persistantStore setObject:userData forKey:kPersistantStoreCurrentUser];
    [persistantStore synchronize];
    
    //This function saves the the new current user to the local roommate array.
    [HPCentralData saveRoommatesWithSingleRoommate:roommate];
    
    return true;
}

//Checks if the home exists in local storage and if it doesn't it pulls it from parse and stores it in local storage.
+(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block
{
    __block NSData  *homeData = [persistantStore objectForKey:kPersistantStoreHome];
    __block HPHouse *home = [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    
    if (home == nil)
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            home = [[HPHouse alloc] init];
            [[PFUser currentUser] refresh];
            __block PFObject *parseHome = [[PFUser currentUser] objectForKey:@"home"];
            if (parseHome == nil)
            {
                //No home exists for this user yet.
                if (block)
                    block(nil, nil);
                return;
            }
            
            [parseHome fetch];
            home.houseName = [parseHome objectForKey:@"name"];
            home.objectId = [parseHome objectId];
            
            //Get the parse GeoPoint and convert it into a location to be stored locally
            PFGeoPoint *parseGeoPoint = [parseHome objectForKey:@"location"];
            if (parseGeoPoint != nil) {
                CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:parseGeoPoint.latitude longitude:parseGeoPoint.longitude];
                home.location = newLocation;
            }
            
            home.addressText = [parseHome objectForKey:@"addressText"];
            
            //convert roommate object into encoded data to store in NSUserdefault
            homeData = [NSKeyedArchiver archivedDataWithRootObject:home];
            [persistantStore setObject:homeData forKey:kPersistantStoreHome];
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
    NSData *homeData = [persistantStore objectForKey:kPersistantStoreHome];
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
        home.objectId = [parseHome objectId];
        
        //Get the parse GeoPoint and convert it into a location to be stored locally
        PFGeoPoint *parseGeoPoint = [parseHome objectForKey:@"location"];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:parseGeoPoint.latitude longitude:parseGeoPoint.longitude];
        home.location = newLocation;
        
        home.addressText = [parseHome objectForKey:@"addressText"];
        
        
        //convert roommate object into encoded data to store in NSUserdefault
        homeData = [NSKeyedArchiver archivedDataWithRootObject:home];
        [persistantStore setObject:homeData forKey:kPersistantStoreHome];
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
        [persistantStore setObject:homeData forKey:kPersistantStoreHome];
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
    [persistantStore setObject:homeData forKey:kPersistantStoreHome];
    [persistantStore synchronize];
    
    return true;
}

#pragma mark - ToDoList Saving and Getting

+ (void)saveNewToDoListEntryWithName:(NSString *)name
{
    //Save the new entry locally.
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    ListItem *newListItem = [NSEntityDescription insertNewObjectForEntityForName:@"CDListItem" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    newListItem.name = name;
    newListItem.createdAt = [[NSDate date] timeIntervalSince1970];
    newListItem.isComplete = NO;
    
    [coreDataStack saveContext];
    
    PFObject *pfNewListEntry = [PFObject objectWithClassName:@"Entry"];
    
    [pfNewListEntry setObject:@"ToDo List" forKey:@"listName"];
    
    //GetHouseForUser
    [pfNewListEntry setObject:[HPCentralData getHouse].objectId forKey:@"houseObjectId"];
    [pfNewListEntry setObject:newListItem.name forKey:@"description"];
    [pfNewListEntry setObject:[NSNumber numberWithBool:false] forKey:@"isComplete"];
    
    [pfNewListEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //We save the context twice because saving to parse can take some time.
        newListItem.parseObjectId = pfNewListEntry.objectId;
        [coreDataStack saveContext];
    }];
}

+ (void)deleteToDoListEntryWithCell:(NSIndexPath *)indexPath andFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    //Find the item in local storage.
    ListItem *listItemToDelete = [fetchedResultsController objectAtIndexPath:indexPath];
    
    //Delete it from the cloud.
    if (listItemToDelete.parseObjectId) {
        PFObject *pfNewListEntry = [PFObject objectWithoutDataWithClassName:@"Entry" objectId:listItemToDelete.parseObjectId];
        [pfNewListEntry deleteInBackground];
    }
    
    //Delete the item in local storage.
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    [coreDataStack.managedObjectContext deleteObject:listItemToDelete];
    [coreDataStack saveContext];
    
    
    
}

+ (void) updateToDoListCompletedStatusWithStatus:(BOOL)status atIndexPath:(NSIndexPath *)indexPath andFetchedResultsContoller:(NSFetchedResultsController *)fetchedResultsController
{
    //Find the item in local storage.
    ListItem *listItemToUpdate = [fetchedResultsController objectAtIndexPath:indexPath];
    listItemToUpdate.isComplete = status;
    
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];

    if (status == YES)
    {
        //Get roommate from local store that matches the current user
        Roommate *currentUser = [HPCentralData getRoommateFromLocalStoreWithRoommateParseObjectId:[PFUser currentUser].objectId];

        if (currentUser)
        {
            listItemToUpdate.completedBy = currentUser;
            listItemToUpdate.isComplete = YES;
            listItemToUpdate.completedAt = [NSDate date].timeIntervalSince1970;
            [coreDataStack saveContext];
        }
    }
    else
    {
        listItemToUpdate.isComplete = NO;
        listItemToUpdate.completedBy = nil;
        [coreDataStack saveContext];
    }

    
    //Save to cloud
    PFObject *pfNewListEntry;
    pfNewListEntry = [PFObject objectWithoutDataWithClassName:@"Entry" objectId:listItemToUpdate.parseObjectId];
    [pfNewListEntry setObject:[NSNumber numberWithBool:listItemToUpdate.isComplete] forKey:@"isComplete"];
    [pfNewListEntry setObject:[listItemToUpdate completedBy].parseObjectId ? [PFUser currentUser] : [NSNull null] forKey:@"completedBy"];
    [pfNewListEntry setObject:(listItemToUpdate.completedAt > NSTimeIntervalSince1970) ? [NSDate dateWithTimeIntervalSince1970:listItemToUpdate.completedAt ] : [NSNull null] forKey:@"completedAt"];
    
    [pfNewListEntry saveInBackground];
}

+ (Roommate *) getRoommateFromLocalStoreWithRoommateParseObjectId:(NSString *) objectId
{
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    //Get roommate from local store that matches the current user
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRoommate" inManagedObjectContext:coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectId==%@",
                              objectId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"Error: %@", error);
    
    if ([results count] < 1)
    {
        return nil;
    }
    else
    {
        return results[0];
    }
}

+ (Roommate *) getRoommateFromLocalStoreWithListItemParseObjectId:(NSString *) objectId
{
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    //Get roommate from local store that matches the current user
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRoommate" inManagedObjectContext:coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectId == %@",
                              objectId ];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error Fetching: %@", error);
        return nil;
    }
    
    if ([results count] < 1)
    {
        return nil;
    }
    else
    {
        return results[0];
    }
}


+ (void)refreshAllListEntriesFromCloudInBackgroundWithBlock:(CentralDataGenericResultBlock)block
{
    HPHouse *house = [HPCentralData getHouse];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Entry"];
    [query whereKey:@"houseObjectId" equalTo:house.objectId];
    [query includeKey:@"completedBy.objectId"];
    [query includeKey:@"createdAt"];
    [query orderByAscending:@"completedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {

        NSArray *pfEntries = objects;
        HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDListItem" inManagedObjectContext:coreDataStack.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        error = nil;
        NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        [HPCentralData findAndDeleteLocalEntiresThatHaveBeenDeletedRemotelyWithRemoteObject:pfEntries andLocalObjects:results];
        [HPCentralData findNewRemoteListItemsAndUpdateOldOnesToAddToTheLocalStoreWithRemoteObjects:pfEntries andLocalObjects:results];
        
        
        [coreDataStack saveContext];
    
        if (block)
        {
            block(error);
        }
        
        
    }];
}

+ (void) findAndDeleteLocalEntiresThatHaveBeenDeletedRemotelyWithRemoteObject:(NSArray *)remoteObjects andLocalObjects:(NSArray *)localObjects
{
    for (ListItem *localItem in localObjects)
    {
        BOOL objectWasDeletedRemotely = YES;
        for (PFObject *remoteItem in remoteObjects)
        {
            if ([localItem.parseObjectId isEqualToString:remoteItem.objectId]) {
                objectWasDeletedRemotely = NO;
                break;
            }
        }
        if (objectWasDeletedRemotely) {
            [[HPCoreDataStack defaultStack].managedObjectContext deleteObject:localItem];
        }
    }

}

+ (void) findNewRemoteListItemsAndUpdateOldOnesToAddToTheLocalStoreWithRemoteObjects:(NSArray *)remoteObjects andLocalObjects:(NSArray *)localObjects
{
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    for (PFObject *remoteItem in remoteObjects)
    {
        BOOL hasLocalObject = NO;
        for (ListItem *localItem in localObjects)
        {
            if ([remoteItem.objectId isEqualToString:localItem.parseObjectId])
            {
                hasLocalObject = YES;
                localItem.isComplete = [[remoteItem objectForKey:@"isComplete"] boolValue];
                PFObject *roommate = [remoteItem objectForKey:@"completedBy"];
                if (![roommate isEqual:[NSNull null]])
                {
                    localItem.completedBy = [HPCentralData getRoommateFromLocalStoreWithRoommateParseObjectId:roommate.objectId];
                }
                
                break;
            }
        }
        if (hasLocalObject == NO)
        {
            ListItem *newListItem = [NSEntityDescription insertNewObjectForEntityForName:@"CDListItem" inManagedObjectContext:coreDataStack.managedObjectContext];
            
            newListItem.name = [remoteItem objectForKey:@"description"];
            NSLog(@"%@", newListItem.name);
            
            newListItem.createdAt = [remoteItem.createdAt timeIntervalSince1970];
            newListItem.isComplete = [[remoteItem objectForKey:@"isComplete"] boolValue];
            NSLog(@"%d", newListItem.isComplete);
            
            newListItem.parseObjectId = remoteItem.objectId;
            PFUser *completedBy = [remoteItem objectForKey:@"completedBy"];
            if(![completedBy isEqual:[NSNull null]])
            {
                NSLog(@"%@", completedBy.objectId);
                newListItem.completedBy = [HPCentralData getRoommateFromLocalStoreWithRoommateParseObjectId:completedBy.objectId];
            }
            else
            {
                newListItem.completedBy = nil;
            }
            
        }
    }
}

+ (NSFetchRequest *) getAllToDoListEntriesFetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDListItem"];
    
    //This sort descripor should arrange entries with uncompleted at the top and completed at the bottom and then sort by their created date.
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isComplete" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    
    return fetchRequest;
}

#pragma mark - Roommates getters and savers.
+ (void)refreshAllRoommatesFromCloudInBackgroundWithBlock:(CentralDataGenericResultBlock)block
{
    //Needed to manually use background thread because of potential profile picture download.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //First Get Remote Items.
        PFQuery *query = [PFQuery queryWithClassName:@"House"];
        [query includeKey:@"users"];
        PFObject *parseHome = [query getObjectWithId:[[[PFUser currentUser] objectForKey:@"home"] objectId]];
        NSArray *pfRoommates = [parseHome objectForKey:@"users"];
        
        //Next get local Items.
        HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRoommate" inManagedObjectContext:coreDataStack.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        [HPCentralData findNewRemoteRoommatesAndUpdateOldOnesToAddToTheLocalStoreWithRemoteObjects:pfRoommates andLocalObjects:results];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(nil);
            [coreDataStack saveContext];
        });
    });
    

}

+ (void) findNewRemoteRoommatesAndUpdateOldOnesToAddToTheLocalStoreWithRemoteObjects:(NSArray *)remoteObjects andLocalObjects:(NSArray *)localObjects
{
    HPCoreDataStack *coreDataStack = [HPCoreDataStack defaultStack];
    for (PFObject *remoteItem in remoteObjects)
    {
        BOOL hasLocalObject = NO;
        for (Roommate *localItem in localObjects)
        {
            if ([remoteItem.objectId isEqualToString:localItem.parseObjectId])
            {
                //Check update the profile picture.
                hasLocalObject = YES;
                
                //Only get profile picture if it's been updated since last fetch.
                if ([[NSDate dateWithTimeIntervalSince1970:localItem.updatedAt] compare:remoteItem.updatedAt] != NSOrderedSame)
                {
                    PFFile *userImageFile = [remoteItem objectForKey:@"profilePic"];
                    localItem.profilePicture = [userImageFile getData];
                }
                
                localItem.updatedAt = [remoteItem.updatedAt timeIntervalSince1970];

                break;
            }
        }
        if (hasLocalObject == NO)
        {
            Roommate *newRoommate = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoommate" inManagedObjectContext:coreDataStack.managedObjectContext];
            
            newRoommate.name = [remoteItem objectForKey:@"username"];
            newRoommate.parseObjectId = remoteItem.objectId;
            newRoommate.updatedAt = [remoteItem.updatedAt timeIntervalSince1970];
            
            PFFile *userImageFile = [remoteItem objectForKey:@"profilePic"];
            newRoommate.profilePicture = [userImageFile getData];
            
        }
    }
}



+(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [HPCentralData clearLocalRoommatesData];
        NSArray *roommates = [HPCentralData getRoommates];
        NSError *error;
        if (!roommates)
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"saving roommates failed" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"roommates" code:100 userInfo:details];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(roommates, error);
        });
    });
}

+ (NSArray *) getRoommates
{
    NSMutableArray *roommatesData = [persistantStore objectForKey:kPersistantStoreRoommates];
    NSMutableArray *roommates = [[NSMutableArray alloc] init];
    
    for (NSData *roommateData in roommatesData) {
        HPRoommate *roommate = [NSKeyedUnarchiver unarchiveObjectWithData:roommateData];
        [roommates addObject:roommate];
    }
    
    if ([roommates count] == 0)
    {
        roommatesData = [[NSMutableArray alloc] init];
        
        //As long as user is saved in the cloud we must refresh here. Trust me.
        [[PFUser currentUser] refresh];
        //pulling from parse
        
        PFQuery *query = [PFQuery queryWithClassName:@"House"];
        [query includeKey:@"users"];
        
        PFObject *parseHome = [query getObjectWithId:[[[PFUser currentUser] objectForKey:@"home"] objectId]];
        if (parseHome == nil)
        {
            //No home exists for this user yet.
            return nil;
        }

        NSArray *pfRoommates = [parseHome objectForKey:@"users"];
        for (PFObject *pfRoommate in pfRoommates) {
            HPRoommate * roommate = [[HPRoommate alloc] init];
            roommate.username = pfRoommate[@"username"];
            roommate.objectId = [pfRoommate objectId];
            [roommate setAtHomeString:pfRoommate[@"atHome"]];
            
            
            PFFile *userImageFile = [pfRoommate objectForKey:@"profilePic"];
            roommate.profilePic = [UIImage imageWithData:[userImageFile getData]];
            
            [roommates addObject:roommate];
            
            NSData *roommateData = [NSKeyedArchiver archivedDataWithRootObject:roommate];
            [roommatesData addObject:roommateData];
        }
        
        [persistantStore setObject:roommatesData forKey:kPersistantStoreRoommates];
        [persistantStore synchronize];
        
    }
    
    return roommates;
}

//You need to pass a username here bacause it is possible that a roommate object will have a null username
+ (bool)saveRoommatesWithSingleRoommate:(HPRoommate *)roommate
{
    NSMutableArray *roommatesData = [[NSMutableArray alloc] init];
    //Find the user in the local storage roommate array.
    if (!roommate.username) {
        [NSException raise:@"HP Exception: Invalid roommate sent to saveRoommatesWithSingleRoommate" format:@"roommate of %@ is invalid", roommate];
    }
    NSMutableArray *roommates = [NSMutableArray arrayWithArray:[HPCentralData getRoommates]];
    
    for (int roommateCount = 0; roommateCount < [roommates count]; roommateCount++) {
        HPRoommate *roommateToFind = [roommates objectAtIndex:roommateCount];
        if ([roommateToFind.username isEqualToString:roommate.username]) {
            [roommates replaceObjectAtIndex:roommateCount withObject:roommate];
        }
    }
    
    //Loop through and convert all the roommates into data
    for (HPRoommate* roomateToConvertToData in roommates) {
        NSData *roommateData = [NSKeyedArchiver archivedDataWithRootObject:roomateToConvertToData];
        [roommatesData addObject:roommateData];
    }
    
    [persistantStore setObject:roommatesData forKey:kPersistantStoreRoommates];
    [persistantStore synchronize];
    
    return true;
}

#pragma mark - House Helper Methods

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

#pragma mark - CurrentUser Helper Methods

+ (bool)transferAttributesFromUser:(HPRoommate *)roommate toPFObject:(PFObject *)parseUser
{
    //Set the new attributes as long as they are not null. If they are null we assume keep the old NSUserDefault values.
    if ([roommate username] != nil) {
       parseUser[@"username"] = roommate.username;
    }
    
    if ([roommate profilePic] != nil) {
        NSData *imageData = UIImagePNGRepresentation(roommate.profilePic);
        PFFile *imageFile = [PFFile fileWithName:@"profile_pic.jpg" data:imageData];
        parseUser[@"profilePic"] = imageFile;
    }

#warning This logic requires that the UI always pass an atHomeString when modifying the user. Otherwise it will be set to null. Can this be better thought out?
    if ([roommate atHomeString] != nil) {
        parseUser[@"atHome"] = [roommate atHomeString];
    }
    else
    {
        parseUser[@"atHome"] = @"unknown";
    }
    
    //Make sure the user is logged in.
    if ([PFUser currentUser] != nil)
    {
        if ([parseUser save] == false) {
            return false;
        }
    }
    else
    {
        NSLog(@"Tried to save a logged out user.");
    }
    
    return true;
}

//This function fills in any blankspaces in the new roommate with the old roommates attributes. This prevents blanks being stored in local storage.
+ (HPRoommate *) transferOldRoommate:(HPRoommate *)oldRoommate toNewRoomate:(HPRoommate *)newRoommate
{
    //Set the new attributes as long as they are not null. If they are null we assume keep the old NSUserDefault values.
    if ([newRoommate username] == nil) {
        newRoommate.username = oldRoommate.username;
    }
    
    if ([newRoommate profilePic] == nil) {
        newRoommate.profilePic = oldRoommate.profilePic;
    }
    
    if ([newRoommate atHomeString] == nil) {
        newRoommate.atHomeString = oldRoommate.atHomeString;
    }

    return newRoommate;
}


//setStateFirstTimeLoginTrue and getStateFirstTimeLoginAndSetToFalse are methods that get to store the track whether a user is new or not.
+ (void) setStateFirstTimeLogin:(bool)state
{
    [persistantStore setObject:[NSNumber numberWithBool:state] forKey:kPersistantStoreNewUser];
    [persistantStore synchronize];
}

//By calling this method you are stating that the current user is no longer new.
+ (bool) getStateFirstTimeLoginAndSetToFalse
{
    NSNumber *currentStateNumber = [persistantStore objectForKey:kPersistantStoreNewUser];
    
    if (currentStateNumber == nil) {
        return false;
    }

    bool currentState = [currentStateNumber boolValue];
    
    [persistantStore setObject:[NSNumber numberWithBool:false] forKey:kPersistantStoreNewUser];
    [persistantStore synchronize];
    
    return currentState;
}

+ (bool) userWithHouseInLocalStorage
{
    NSData *homeData = [persistantStore objectForKey:kPersistantStoreHome];
    HPHouse *home =  [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    
    if (home && [PFUser currentUser]) {
        return true;
    }
    else
    {
        return false;
    }
    
}
@end
