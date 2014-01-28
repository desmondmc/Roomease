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

-(void) getHouseInBackgroundWithBlock:(CentralDataHouseResultBlock)block;
-(void) getRoommatesInBackgroundWithBlock:(CentralDataUsersResultBlock)block;

@end
