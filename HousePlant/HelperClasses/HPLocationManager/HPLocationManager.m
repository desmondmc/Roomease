//
//  HPLocationManager.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/12/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPLocationManager.h"

@implementation HPLocationManager

//Simply asks the user to allow the app access to their location.
+ (void)initHPLocationManagerWithDelegate:(id)delegate {
    kApplicationDelegate.hpLocationManager = [[HPLocationManager alloc] initWithDelegate:delegate];
}

- (id)initWithDelegate:(id)delegate {
    if (self = [super init]) {
       _locationManager = [[CLLocationManager alloc] init];
       _locationManager.delegate = delegate;
       _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       // Set a movement threshold for new events.
       _locationManager.distanceFilter = 500; // meters
       [_locationManager startUpdatingLocation];
    }
    return self;
}

+ (bool)setRegionToMonitorWithIdentifier:(NSString *)identifier latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius
{
    NSString *regionIdentifier = identifier;
    CLLocationDegrees regionLatitude = latitude;
    CLLocationDegrees regionLongitude = longitude;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(regionLatitude, regionLongitude);
    CLLocationDistance regionRadius = radius;
    
    
    if(regionRadius > kApplicationDelegate.hpLocationManager.locationManager.maximumRegionMonitoringDistance)
    {
        regionRadius = kApplicationDelegate.hpLocationManager.locationManager.maximumRegionMonitoringDistance;
    }
    
    CLRegion * region =nil;
    
    region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                    radius:regionRadius
                                                identifier:regionIdentifier];
    
    [kApplicationDelegate.hpLocationManager.locationManager startMonitoringForRegion:region];
    
    
    [[[HPHouse alloc] init] setLocalStorageRegion:region];
    
    return true;
}

+ (void) requestStateForCurrentHouseLocation
{
    //Get house from central data and check if the region attribute is set.
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
        if ([house addressText] != nil)
        {
            //There is an address. Has region been calculated and stored?
            if ([house region] == nil) {
                [HPLocationManager setRegionToMonitorWithIdentifier:kHomeLocationIdentifier latitude:house.location.coordinate.latitude longitude:house.location.coordinate.longitude radius:kDefaultHouseRadius];
            }
            
            CLRegion *houseRegion = [house getLocalStorageRegion];
            if (houseRegion != nil)
            {
                // Force request for location
                [kApplicationDelegate.hpLocationManager.locationManager requestStateForRegion:houseRegion];
            }
        }
    }];
}

+ (NSString *) checkLocationServicePermissions
{
    if(![CLLocationManager locationServicesEnabled])
    {
        //You need to enable Location Services
        return @"Location Services is globally turned off.";
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
    {
        NSLog(@"Not sure what the hell this means? (![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]");
        return nil;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        return @"Roomease location services is disabled.";
    }
    return nil;
}

#pragma mark - Helper Methods

@end
