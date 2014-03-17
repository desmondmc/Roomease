//
//  HPCentralData.h
//  RoomEase
//
//  Created by Desmond McNamee on 1/9/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPersistantStoreHome @"hp_home"
#define kPersistantStoreCurrentUser @"hp_currentUser"
#define kPersistantStoreRoommates @"hp_roommates"

@interface HPCentralData : NSObject

+(void) clearCentralData;
+(void) clearLocalHouseData;
+(void) clearLocalRoommatesData;

+(void) resyncAllData;
+(void) resyncCurrentUser;
+(void) resyncHouse;
+(void) resyncRoommates:(CentralDataSaveResultBlock)block;

+(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block;
+(HPRoommate *) getCurrentUser;
+(void) saveCurrentUserInBackgroundWithRoommate:(HPRoommate*)roommate andBlock:(CentralDataSaveResultBlock)block;
+(bool) saveCurrentUser:(HPRoommate *)roommate;

+(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block;
+(HPHouse *) getHouse;
+(void) saveHouseInBackgroundWithHouse:(HPHouse *)house andBlock:(CentralDataSaveResultBlock)block;
+(bool) saveHouse:(HPHouse *)house;

+(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block;
+(NSArray *) getRoommates;



@end
