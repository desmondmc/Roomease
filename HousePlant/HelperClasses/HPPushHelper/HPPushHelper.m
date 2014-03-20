//
//  HPPushHelper.m
//  RoomEase
//
//  Created by Gregory Flatt on 3/5/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPPushHelper.h"

@implementation HPPushHelper


+ (void)sendNotificationWithMessage:(NSString*)message toChannel:(NSString*)channel
{
    [PFPush sendPushMessageToChannelInBackground:channel
                                     withMessage:message block:^(BOOL succeeded, NSError *error)
     {
         if(error)
         {
             NSLog(@"Error sending push with message.");
         }
         
     }];
}

+ (void)sendNotificationWithData:(NSDictionary *)data toChannel:(NSString*)channel andAlert:(NSString *)alert
{
    PFPush *message = [[PFPush alloc] init];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:data];
    if (alert != nil) {
        [newDict setValue:alert forKey:@"alert"];
    }
    
    [message setChannel:channel];
    [message setData:newDict];
    [message sendPushInBackground];
}

+ (void)sendNotificationWithDataToEveryoneInHouseButMe:(NSDictionary *)data andAlert:(NSString *)alert
{
    [[PFUser currentUser] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [HPCentralData getRoommatesInBackgroundWithBlock:^(NSArray *roommates, NSError *error) {
            if(alert == nil && data == nil)
            {
                return; //nothing to send.
            }
            for (HPRoommate *roommate in roommates) {
                if (![[roommate username] isEqualToString:[PFUser currentUser].username]) {
                    PFQuery *query = [PFInstallation query];
                    [query whereKey:@"channels" equalTo:roommate.username];
                    
                    PFPush *message = [[PFPush alloc] init];
                    
                    NSMutableDictionary *newDict;
                    if (data != nil)
                    {
                        newDict = [NSMutableDictionary dictionaryWithDictionary:data];
                    }
                    else
                    {
                        newDict = [[NSMutableDictionary alloc] init];
                    }
                    
                    if (alert != nil) {
                        [newDict setValue:alert forKey:@"alert"];
                    }
                    
                    [message setQuery:query];
                    [message setData:newDict];
                    [message sendPushInBackground];
                }
            }
        }];
    }];
}

@end
