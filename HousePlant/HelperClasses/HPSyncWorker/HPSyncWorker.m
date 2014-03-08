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

+(BOOL) handleSyncRequestWithType:(syncRequest_t)type
{
    switch (type)
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
    
    return true;
}

+(BOOL) handleSyncRequestWithDictionary:(NSDictionary *)syncData
{
    syncRequest_t request = [[syncData objectForKey:@"syncRequestKey"] intValue];
    
    return [self handleSyncRequestWithType:request];
}

@end
