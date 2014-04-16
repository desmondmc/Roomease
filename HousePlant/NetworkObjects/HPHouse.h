//
//  HPHouse.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/12/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPNetworkObject.h"
#import <CoreLocation/CoreLocation.h>

@interface HPHouse : HPNetworkObject

@property (strong, nonatomic) NSString *houseName;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *addressText;
@property (strong, nonatomic) NSString *objectId;

//The region property is not stored on the server. It is only ever stored locally. User the overrided setLocalStorageRegion call if you'd just like to set the region of a house. No need to go through central data because it is not stored in parse.
@property (strong, nonatomic) CLRegion *region;


-(void) setLocalStorageRegion:(CLRegion *)region;
-(CLRegion *) getLocalStorageRegion;

@end
