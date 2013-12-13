//
//  HPUser.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/12/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPNetworkObject.h"
#import "HPHouse.h"
#import <CoreLocation/CoreLocation.h>

@interface HPUser : HPNetworkObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) HPHouse *house;
@property (strong, nonatomic) CLLocation *location;

+(void) loginUser;


@end
