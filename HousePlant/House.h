//
//  House.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-21.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem, Roommate;

@interface House : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSSet *roommates;
@property (nonatomic, retain) NSSet *listItems;
@end

@interface House (CoreDataGeneratedAccessors)

- (void)addRoommatesObject:(Roommate *)value;
- (void)removeRoommatesObject:(Roommate *)value;
- (void)addRoommates:(NSSet *)values;
- (void)removeRoommates:(NSSet *)values;

- (void)addListItemsObject:(ListItem *)value;
- (void)removeListItemsObject:(ListItem *)value;
- (void)addListItems:(NSSet *)values;
- (void)removeListItems:(NSSet *)values;

@end
