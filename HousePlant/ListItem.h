//
//  ListItem.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-26.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class House, Roommate;

@interface ListItem : NSManagedObject

@property (nonatomic) NSTimeInterval completedAt;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL isComplete;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) Roommate *completedBy;
@property (nonatomic, retain) House *house;

@end
