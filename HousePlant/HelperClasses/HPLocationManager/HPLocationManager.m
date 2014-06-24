//
//  HPLocationManager.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/12/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPLocationManager.h"

@implementation HPLocationManager

/************New functions***********/

+ (id)sharedLocationManager
{
    static HPLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
#warning kCLLocationAccuracyBest might be hard on the battery life.
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Set a movement threshold for new events.
#warning make sure events are not being triggered constantly
        _locationManager.distanceFilter = 100; // meters
        [_locationManager startUpdatingLocation];
        kApplicationDelegate.appLocationManager = _locationManager;
    }
    return self;
}

- (void) saveNewHouseLocationInBackgroundWithAddressString:(NSString *)addressString andBlock:(LocationManagerSaveResultBlock)block
{
    if (addressString == nil)
    {
        HPHouse *house = [[HPHouse alloc] init];
        
        [house setLocation:[self lastLocation]];
        [house setAddressText:addressString];
        
        [HPCentralData saveHouseInBackgroundWithHouse:house andBlock:^(NSError *error) {
            if (!error) {
                if (block) {
                    block(nil);
                }
            }
            else
            {
                if (block) {
                    block(@"Error saving house.");
                }
            }
            
        }];
    }
    else
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:addressString inRegion:nil
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         NSLog(@"placemarks: %@", placemarks);
                         if (placemarks)
                         {
                             CLPlacemark *placeMark = ((CLPlacemark *)[placemarks objectAtIndex:0]);
                             
                             HPHouse *house = [[HPHouse alloc] init];
                             
                             [house setLocation:placeMark.location];
                             [house setAddressText:addressString];
                             
                             [HPCentralData saveHouseInBackgroundWithHouse:house andBlock:^(NSError *error) {
                                 if (!error) {
                                     if (block) {
                                         block(nil);
                                     }
                                 }
                                 else
                                 {
                                     if (block) {
                                         block(@"Error saving house.");
                                     }
                                 }
                                 
                             }];
                         }
                         else
                         {
                             if (block) {
                                 block(@"Could not find address.");
                             }
                         }
                     }];
    }

}

- (void) updateAtHomeStatus
{
    //Pull latest home address from server.
    [_locationManager setDelegate:self];
    
    [HPCentralData clearLocalHouseData];
    [HPCentralData clearLocalRoommatesData];
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        
        //Start monitoring it.
        if (house.location != nil) {
            NSLog(@"house.addressText: %@", house.addressText);
            NSLog(@"house.location: %@", house.location);
            CLRegion *region = [self setRegionToMonitorWithIdentifier:kHomeLocationIdentifier latitude:house.location.coordinate.latitude longitude:house.location.coordinate.longitude radius:kDefaultHouseRadius];
            
            [self requestStateForRegion:region];
        }
    }];
}

- (CLRegion *)setRegionToMonitorWithIdentifier:(NSString *)identifier latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius
{
    NSString *regionIdentifier = identifier;
    CLLocationDegrees regionLatitude = latitude;
    CLLocationDegrees regionLongitude = longitude;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(regionLatitude, regionLongitude);
    CLLocationDistance regionRadius = radius;
    
    
    if(regionRadius > self.locationManager.maximumRegionMonitoringDistance)
    {
        regionRadius = self.locationManager.maximumRegionMonitoringDistance;
    }
    
    CLCircularRegion * region =nil;
    
    region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                radius:regionRadius
                                            identifier:regionIdentifier];
    
    
    //remove currently monitoring regions.
    NSSet * monitoredRegions = self.locationManager.monitoredRegions;
    if (monitoredRegions.count == 0)
    {
        [self.locationManager startMonitoringForRegion:region];
        [[[HPHouse alloc] init] setLocalStorageRegion:region];
    }
    else
    {
        for (CLCircularRegion *oldRegion in monitoredRegions)
        {
            if (oldRegion.center.latitude != region.center.latitude || oldRegion.center.longitude != region.center.longitude)
            {
                [kApplicationDelegate.appLocationManager stopMonitoringForRegion:oldRegion];
                [self.locationManager startMonitoringForRegion:region];
                [[[HPHouse alloc] init] setLocalStorageRegion:region];
            }
            
        }
    }
   
    
    return region;
}

//if string is not nil there is an error.
- (void) requestStateForRegion:(CLRegion *)region
{
    NSLog(@"Requesting state for region: %@", region);
    NSLog(@"Monitoring these regions: %@",[self.locationManager monitoredRegions]);
    [self.locationManager requestStateForRegion:region];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self setLastLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    //update the current users location on parse and the local database.
    NSLog(@"Calling did enter region...");
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        //User is inside house location
        NSLog(@"User is inside fence...");
        HPRoommate *roommate = [[HPRoommate alloc] init];
        [roommate setAtHomeString:@"true"];
        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
    }

}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    //update the current users location on parse and the local database.
    NSLog(@"Calling did exit region...");
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        //User is inside house location
        NSLog(@"User is outside fence...");
        HPRoommate *roommate = [[HPRoommate alloc] init];
        [roommate setAtHomeString:@"false"];
        
        
        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:nil];
        
        return;
    }
}

//Called after requestStateForRegion
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    //If location status has changed save the currentUser
    NSLog(@"\n\n$$$$$$$Location manager did determine state...\n\n");
    if ([region.identifier isEqualToString:kHomeLocationIdentifier]) {
        if (state == CLRegionStateInside) {
            //User is inside house location
            NSLog(@"User is inside fence...");
            
            //Check if the location state has changed since last time and save if it has. Either way trigger a refresh.
            [HPCentralData getCurrentUserInBackgroundWithBlock:^(HPRoommate *roommate, NSError *error) {
                if (![[roommate atHomeString] isEqualToString:@"true"]) {
                    HPRoommate *roommate = [[HPRoommate alloc] init];
                    [roommate setAtHomeString:@"true"];
                    [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:^(NSError *error) {
                        //Initiate Roommate sync.
                        [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest andData:nil];
                    }];
                }
                else
                {
                    [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest andData:nil];
                }
                
            }];

            
        }
        else
        {
            //User is outside location or inside
            NSLog(@"User is outside fence...");
            
            //Check if the location state has changed since last time and save if it has. Either way trigger a refresh.
            [HPCentralData getCurrentUserInBackgroundWithBlock:^(HPRoommate *roommate, NSError *error) {
                if (![[roommate atHomeString] isEqualToString:@"false"]) {
                    HPRoommate *roommate = [[HPRoommate alloc] init];
                    [roommate setAtHomeString:@"false"];
                    [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommate andBlock:^(NSError *error) {
                        //Initiate Roommate sync.
                        [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest andData:nil];
                    }];
                }
                else
                {
                    [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest andData:nil];
                }
                
            }];
        }
    }
    else
    {
        NSLog(@"Unknown region request...");
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //if it is turned off the user will be set to unknowen.
#warning we need a place that gets notified when location services is turned off. Not even sure if this is possible.
}

// Checks what permissions the app has for location and returns a error string to display if there are restrictions.
+ (NSString *) checkLocationServicePermissions
{
    if(![CLLocationManager locationServicesEnabled])
    {
        //You need to enable Location Services
        return @"Location Services is globally turned off.";
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
    {
        return @"device does not support location services.";
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        return @"Roomease location services is disabled.";
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@"Just dealloced HPLocationManager");
}

@end
