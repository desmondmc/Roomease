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

+(BOOL) handleSyncRequestWithType:(syncRequest_t)type andData:(NSDictionary *)data
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
        case todoListSyncRequest:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [HPCentralData getToDoListEntriesAndForceReloadFromParse:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *notifierDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], kRefreshTodoListKey, nil];
                    [[HPUINotifier sharedUINotifier] notifyDelegatesWithChange:notifierDictionary];
                });
            });

            break;
        }
        case todoListItemSyncRequest:
        {
            [HPCentralData resyncEntryForId:[data objectForKey:@"objectId"] andList:todoListSyncRequest withBlock:^(NSError *error) {
                if (error)
                {
                    NSLog(@"Error resync entry %@", [data objectForKey:@"objectId"]);
                }
                else
                {
                    NSDictionary *notifierDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], kRefreshTodoListKey, nil];
                    [[HPUINotifier sharedUINotifier] notifyDelegatesWithChange:notifierDictionary];
                }
            }];
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
    
    return [self handleSyncRequestWithType:request andData:syncData];
}

@end
