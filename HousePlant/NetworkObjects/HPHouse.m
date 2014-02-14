//
//  HPHouse.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/12/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPHouse.h"

@implementation HPHouse

//NSCoding methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _houseName = [aDecoder decodeObjectForKey:@"housename"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _addressText = [aDecoder decodeObjectForKey:@"addresstext"];
        _region = [aDecoder decodeObjectForKey:@"addresstext"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_houseName forKey:@"housename"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_addressText forKey:@"addresstext"];
    [aCoder encodeObject:_region forKey:@"region"];
}

@end
