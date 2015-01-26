//
//  HPCentralData.h
//  RoomEase
//
//  Created by Desmond McNamee on 1/9/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPSyncWorker.h"

#import "House.h"
#import "Roommate.h"
#import "ListItem+Extention.h"
#import "HPCoreDataStack.h"
#import "HPListTableViewCell.h"

#define kPersistantStoreHome @"hp_home"
#define kPersistantStoreCurrentUser @"hp_currentUser"
#define kPersistantStoreRoommates @"hp_roommates"
#define kPersistantStoreToDoListEntries @"hp_todo_list_entries"
#define kPersistantStoreNewUser @"hp_newuser"

@interface HPCentralData : NSObject

+(void) clearCentralData;
+(void) clearCoreData;
+(void) clearLocalHouseData;
+(void) clearLocalRoommatesData;

+(void) resyncAllData;
+(void) resyncCurrentUser;
+(void) resyncHouse;
+(void) resyncRoommates:(CentralDataSaveResultBlock)block;
+(void) resyncEntryForId:(NSString *)objectId andList:(syncRequest_t)listId withBlock:(CentralDataSaveResultBlock)block;

+(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block;
+(Roommate *) getCurrentUser;
+(void) saveCurrentUserInBackgroundWithRoommate:(HPRoommate*)roommate andBlock:(CentralDataSaveResultBlock)block;
+(bool) saveCurrentUser:(HPRoommate *)roommate;

+(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block;
+(HPHouse *) getHouse;
+(void) saveHouseInBackgroundWithHouse:(HPHouse *)house andBlock:(CentralDataSaveResultBlock)block;
+(bool) saveHouse:(HPHouse *)house;

//TODO Lists
+ (void)saveNewToDoListEntryWithName:(NSString *)name;
+ (void)deleteToDoListEntryWithCell:(NSIndexPath *)indexPath andFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
+ (void)updateToDoListCompletedStatusWithStatus:(BOOL)status atIndexPath:(NSIndexPath *)indexPath andFetchedResultsContoller:(NSFetchedResultsController *)fetchedResultsController;
+ (void)refreshAllListEntriesFromCloudInBackgroundWithBlock:(CentralDataGenericResultBlock)block;
+ (NSFetchRequest *) getAllToDoListEntriesFetchRequest;

//Roommates
+ (void)refreshAllRoommatesFromCloudInBackgroundWithBlock:(CentralDataGenericResultBlock)block;

+(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block;
+(NSArray *) getRoommates;

+ (void) setStateFirstTimeLogin:(bool)state;
+ (bool) getStateFirstTimeLoginAndSetToFalse;
+ (bool) userWithHouseInLocalStorage;





@end
