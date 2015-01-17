//
//  HPListEntry.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-16.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPListEntry.h"

@implementation HPListEntry


-(id) initWithPFObject: (PFObject *) object
{
    if (self = [super init]) {
        _objectId = object.objectId;
        _description2 = object[@"description"];
        _dateAdded = object.createdAt;
        if (![object[@"completedBy"] isEqual:[NSNull null]]) {
            _completedBy = [[HPRoommate alloc] initWithPFObject:object[@"completedBy"]];
            _completedByName = _completedBy.username;
            _completedByImage = _completedBy.profilePic;
            _dateCompleted = object[@"completedAt"];
        }
    }
    
    return self;
}

//Pulling data from NSUserDefaults
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _description2 = [aDecoder decodeObjectForKey:@"description"];
        _dateCompleted = [aDecoder decodeObjectForKey:@"dateCompleted"];
        _dateAdded = [aDecoder decodeObjectForKey:@"dateAdded"];
        _completedByImage = [aDecoder decodeObjectForKey:@"completedByImage"];
        _completedByName = [aDecoder decodeObjectForKey:@"completedByName"];
        _objectId = [aDecoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

//Storing data in NSUSerDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_description2 forKey:@"description"];
    [aCoder encodeObject:_dateCompleted forKey:@"dateCompleted"];
    [aCoder encodeObject:_dateAdded forKey:@"dateAdded"];
    [aCoder encodeObject:_completedByImage forKey:@"completedByImage"];
    [aCoder encodeObject:_completedByName forKey:@"completedByName"];
    [aCoder encodeObject:_objectId forKey:@"objectId"];
}

@end
