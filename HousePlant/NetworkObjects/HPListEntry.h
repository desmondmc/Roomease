//
//  HPListEntry.h
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-16.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPListEntry : HPNetworkObject

@property (strong, nonatomic) NSString      *description;
@property (strong, nonatomic) NSDate        *dateCompleted;
@property (strong, nonatomic) NSDate        *dateAdded;
@property (strong, nonatomic) HPRoommate    *completedBy;

@end
