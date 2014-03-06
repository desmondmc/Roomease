//
//  HPSyncWorker.m
//  RoomEase
//
//  Created by Gregory Flatt on 3/4/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPSyncWorker.h"
#import "HPCentralData.h"
#import "HPUINotifier.h"

@implementation HPSyncWorker

+(BOOL) handleSyncRequest:(NSDictionary *)syncData
{
    syncRequest request = [[syncData objectForKey:@"syncRequestKey"] intValue];
    
    switch (request)
    {
        case roommatesSyncRequest:
        {
            [HPCentralData resyncRoommates:^(NSError *error) {
               if (error)
               {
#warning do something
               }
               else
               {
                   NSDictionary *notifierDictionary = [[NSDictionary alloc] init];
                   [notifierDictionary setValue:[NSNumber numberWithBool:TRUE] forKey:kRefreshRoommatesKey];
                   [[HPUINotifier sharedUINotifier] notifyDelegatesWithChange: notifierDictionary];
               }
            }];
            break;
        }
        case houseSyncRequest:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    
    return TRUE;
}

@end
