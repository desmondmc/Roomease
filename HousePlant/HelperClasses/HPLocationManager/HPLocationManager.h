//
//  HPLocationManager.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/12/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPLocationManager : NSObject

@property (strong, atomic) CLLocationManager *locationManager;

+ (void)initHPLocationManagerWithDelegate:(id)delegate;

+ (bool)setRegionToMonitorWithIdentifier:(NSString *)identifier latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius;

+ (void) requestStateForCurrentHouseLocation;

// Checks what permissions the app has for location and returns a error string to display if there are restrictions.
+ (NSString *) checkLocationServicePermissions;

@end
