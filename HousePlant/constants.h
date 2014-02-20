//
//  constants.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/26/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#ifndef HousePlant_constants_h
#define HousePlant_constants_h

#define kApplicationDelegate    ((HPAppDelegate *)[[UIApplication sharedApplication] delegate])
#define persistantStore [NSUserDefaults standardUserDefaults]

#define kHomeLocationIdentifier @"HOME_IDENTIFIER"
#define kDefaultHouseRadius     20

/*********  COLOURS  *********/
#define kLightBlueColour [UIColor colorWithRed:75/255.0f green:179/255.0f blue:251/255.0f alpha:1.0f]

/*********  NOTIFICATION  *********/

#define NOTIFICATION_APP_BECAME_ACTIVE @"NOTIFICATION_APP_BECAME_ACTIVE"

#endif
