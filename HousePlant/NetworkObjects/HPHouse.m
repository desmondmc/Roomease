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
        _region = [aDecoder decodeObjectForKey:@"region"];
        _objectId = [aDecoder decodeObjectForKey:@"objectId"];
        _password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_houseName forKey:@"housename"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_addressText forKey:@"addresstext"];
    [aCoder encodeObject:_region forKey:@"region"];
    [aCoder encodeObject:_objectId forKey:@"objectId"];
    [aCoder encodeObject:_password forKey:@"password"];
}

//This function should be used to set just the region value. It was created because region is something that is only stored locally. It doesn't make sense to have to go through central data to set a simple value
-(void) setLocalStorageRegion:(CLRegion *)region
{
    NSData *homeData = [persistantStore objectForKey:kPersistantStoreHome];
    HPHouse *oldHome =  [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    self.houseName = oldHome.houseName;
    self.location = oldHome.location;
    self.addressText = oldHome.addressText;
    self.objectId = oldHome.objectId;
    
    self.region = region;
    
    homeData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [persistantStore setObject:homeData forKey:kPersistantStoreHome];
    [persistantStore synchronize];
}

-(CLRegion *) getLocalStorageRegion
{
    NSData *homeData = [persistantStore objectForKey:kPersistantStoreHome];
    HPHouse *home =  [NSKeyedUnarchiver unarchiveObjectWithData:homeData];
    return [home region];
}

@end
