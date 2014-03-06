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
        _atHomeString = [aDecoder decodeObjectForKey:@"atHome"];
    }
    return self;
}

//Storing data in NSUSerDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_profilePic forKey:@"profilePic"];
    [aCoder encodeObject:_atHomeString forKey:@"atHome"];
}

+(NSNumber *) boolWithString:(NSString *)string
{
    if (string)
    {
        if ([string isEqualToString:@"true"])
        {
            return [NSNumber numberWithBool:true];
        }
        else if ([string isEqualToString:@"false"])
        {
            return [NSNumber numberWithBool:false];
        }
        else if ([string isEqualToString:@"unknown"])
        {
            return nil;
        }
        else
        {
            [NSException raise:@"Invalid value for at string" format:@"string of %@ is invalid. Should be true, false, or nil", string];
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

@end
