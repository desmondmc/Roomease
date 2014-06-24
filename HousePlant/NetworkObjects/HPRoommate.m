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
        _objectId = [aDecoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

- (id) initWithPFObject:(PFObject *) object
{
    if (self = [super init]) {
        _username = object[@"username"];
        _objectId = [object objectId];
        [self setAtHomeString:object[@"atHome"]];
        
        
        PFFile *userImageFile = [object objectForKey:@"profilePic"];
        _profilePic = [UIImage imageWithData:[userImageFile getData]];
    }
    
    return self;
}

//Storing data in NSUSerDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_profilePic forKey:@"profilePic"];
    [aCoder encodeObject:_atHomeString forKey:@"atHome"];
    [aCoder encodeObject:_objectId forKey:@"objectId"];
}

#warning Why is this here?
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
