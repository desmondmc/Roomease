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

//The region property is not stored on the server. It is only ever stored locally.
@property (strong, nonatomic) CLRegion *region;

@end
