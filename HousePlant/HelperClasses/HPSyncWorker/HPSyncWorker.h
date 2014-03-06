//
//  HPSyncWorker.h
//  RoomEase
//
//  Created by Gregory Flatt on 3/4/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    roommatesSyncRequest = 0,
    houseSyncRequest,    
}syncRequest;



@interface HPSyncWorker : NSObject

+(BOOL) handleSyncRequest:(NSDictionary *)syncData;

@end
