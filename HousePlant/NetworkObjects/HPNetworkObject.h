//
//  HPNetworkObject.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/12/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>


/*** This should include all methods and instance variables that are common to all network objects ***/



typedef void (^HPNetworkObjectResultBlock)(BOOL succeeded, NSError *error);

@interface HPNetworkObject : NSObject <NSCoding>

- (BOOL) save;
- (BOOL) saveInBackgroundWithBlock:(HPNetworkObjectResultBlock)block;

@end
