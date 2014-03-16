//
//  HPLocationManager.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/12/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LocationManagerSaveResultBlock)(NSString *error);

@interface HPLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, atomic) CLLocationManager *locationManager;

/************New functions***********/
+ (id)sharedLocationManager;


- (void) saveNewHouseLocationInBackgroundWithAddressString:(NSString *)addressString andBlock:(LocationManagerSaveResultBlock)block;

//This will trigger a UI update.
- (void) updateAtHomeStatus;

@end
