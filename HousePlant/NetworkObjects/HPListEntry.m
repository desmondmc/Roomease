//
//  HPListEntry.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-16.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPListEntry.h"

@implementation HPListEntry

//Pulling data from NSUserDefaults
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _description = [aDecoder decodeObjectForKey:@"description"];
        _dateCompleted = [aDecoder decodeObjectForKey:@"dateCompleted"];
        _dateAdded = [aDecoder decodeObjectForKey:@"dateAdded"];
        _completedBy = [aDecoder decodeObjectForKey:@"completedBy"];
        _objectId = [aDecoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

//Storing data in NSUSerDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_dateCompleted forKey:@"dateCompleted"];
    [aCoder encodeObject:_dateAdded forKey:@"dateAdded"];
    [aCoder encodeObject:_completedBy forKey:@"completedBy"];
    [aCoder encodeObject:_objectId forKey:@"objectId"];
}

@end
