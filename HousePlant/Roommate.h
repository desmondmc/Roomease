//
//  Roommate.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-26.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class House, ListItem;

@interface Roommate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSData * profilePicture;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, retain) NSSet *completedListItems;
@property (nonatomic, retain) House *house;
@end

@interface Roommate (CoreDataGeneratedAccessors)

- (void)addCompletedListItemsObject:(ListItem *)value;
- (void)removeCompletedListItemsObject:(ListItem *)value;
- (void)addCompletedListItems:(NSSet *)values;
- (void)removeCompletedListItems:(NSSet *)values;

@end
