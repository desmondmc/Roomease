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

@end
