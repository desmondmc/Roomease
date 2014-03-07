//
//  HPSyncWorker.m
//  RoomEase
//
//  Created by Gregory Flatt on 3/4/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

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
                   NSLog(@"Error resyncing roommates!!");
               }
               else
               {
                   NSDictionary *notifierDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], kRefreshRoommatesKey, nil];
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