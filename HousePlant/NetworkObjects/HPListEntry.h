//
//  HPListEntry.h
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-16.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPListEntry : HPNetworkObject
-(id) initWithPFObject: (PFObject *) object;
@property (strong, nonatomic) NSString      *description;
@property (strong, nonatomic) NSDate        *dateCompleted;
@property (strong, nonatomic) NSDate        *dateAdded;
@property (strong, nonatomic) HPRoommate    *completedBy;
@property (strong, nonatomic) NSString      *completedByName;
@property (strong, nonatomic) UIImage        *completedByImage;
@property (strong, nonatomic) NSString      *objectId;

@end
