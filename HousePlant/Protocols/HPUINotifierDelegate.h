//
//  HPUINotifierDelegate.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/26/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

/********DEFINES**********/

#define kRefreshRoommatesKey @"refreshRoommatesKey"
#define kRefreshTodoListKey      @"refreshTodoListKey"
#define kRefreshTodoListItemKey      @"refreshTodoListItemKey"


@protocol HPUINotifierDelegate <NSObject>

@required

//Should be called when new data is available and the UI should be updated to reflect the new data.
-(void) resyncUIWithDictionary:(NSDictionary *)uiChanges;

@end
