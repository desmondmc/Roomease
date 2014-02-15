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

- (bool)setRegionToMonitorWithIdentifier:(NSString *)identifier latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius
{
    NSString *regionIdentifier = identifier;
    CLLocationDegrees regionLatitude = latitude;
    CLLocationDegrees regionLongitude = longitude;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(regionLatitude, regionLongitude);
    CLLocationDistance regionRadius = radius;
    
    
    if(regionRadius > kApplicationDelegate.locationManager.locationManager.maximumRegionMonitoringDistance)
    {
        regionRadius = kApplicationDelegate.locationManager.locationManager.maximumRegionMonitoringDistance;
    }
    
    CLRegion * region =nil;
    
    region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                    radius:regionRadius
                                                identifier:regionIdentifier];
    
    [kApplicationDelegate.locationManager.locationManager startMonitoringForRegion:region];
    
    
    [[[HPHouse alloc] init] setLocalStorageRegion:region];
    
    return true;
}



@end
