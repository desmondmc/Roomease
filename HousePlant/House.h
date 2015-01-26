//
//  House.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-26.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem, Roommate;

@interface House : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSSet *listItems;
@property (nonatomic, retain) NSSet *roommates;
@end

@interface House (CoreDataGeneratedAccessors)

- (void)addListItemsObject:(ListItem *)value;
- (void)removeListItemsObject:(ListItem *)value;
- (void)addListItems:(NSSet *)values;
- (void)removeListItems:(NSSet *)values;

- (void)addRoommatesObject:(Roommate *)value;
- (void)removeRoommatesObject:(Roommate *)value;
- (void)addRoommates:(NSSet *)values;
- (void)removeRoommates:(NSSet *)values;

@end
