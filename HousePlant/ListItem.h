//
//  ListItem.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-21.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class House, Roommate;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSTimeInterval completedAt;
@property (nonatomic) BOOL isComplete;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) Roommate *completedBy;
@property (nonatomic, retain) House *house;

@end
