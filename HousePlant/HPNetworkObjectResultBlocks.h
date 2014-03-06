//
//  HPNetworkObjectResultBlocks.h
//  RoomEase
//
//  Created by Desmond McNamee on 1/28/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#ifndef RoomEase_HPNetworkObjectResultBlocks_h
#define RoomEase_HPNetworkObjectResultBlocks_h

#include "HPHouse.h"
#include "HPRoommate.h"

typedef void (^CentralDataHouseResultBlock)(HPHouse *house, NSError *error);
typedef void (^CentralDataRoommatesResultBlock)(NSArray *roommates, NSError *error);
typedef void (^CentralDataRoommateResultBlock)(HPRoommate *roommate, NSError *error);
typedef void (^CentralDataSaveResultBlock)(NSError *error);
#endif
