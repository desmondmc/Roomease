//
//  HPCentralData.h
//  RoomEase
//
//  Created by Desmond McNamee on 1/9/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPCentralData : NSObject

-(void) resyncAllData;
-(void) resyncCurrentUser;
-(void) resyncHouse;
-(void) resyncRoommates;

-(void) getCurrentUserInBackgroundWithBlock:(CentralDataRoommateResultBlock)block;
-(HPRoommate *) getCurrentUser;

-(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block;
-(HPHouse *) getHouse;

-(void) saveHouseInBackgroundWithHouse:(HPHouse *)house andBlock:(CentralDataSaveResultBlock)block;
-(void) saveHouse:(HPHouse *)house;

-(void) getRoommatesInBackgroundWithBlock:(CentralDataRoommatesResultBlock)block;
-(NSArray *) getRoommates;



@end
