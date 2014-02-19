//
//  HPRoommate.m
//  RoomEase
//
//  Created by Desmond McNamee on 1/28/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPRoommate.h"

@implementation HPRoommate

//NSCoding methods

//Pulling data from NSUserDefaults
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _profilePic = [aDecoder decodeObjectForKey:@"profilePic"];
        bool atHomeHolder = [aDecoder decodeIntegerForKey:@"atHome"];
        _atHome = [[NSNumber alloc] initWithBool:atHomeHolder];
    }
    return self;
}

//Storing data in NSUSerDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_profilePic forKey:@"profilePic"];
    [aCoder encodeInteger:_atHome.boolValue forKey:@"atHome"];
}

@end
