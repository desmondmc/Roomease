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
#warning something
         }
         
     }];
}

+ (void)sendNotificationWithData:(NSDictionary *)data toChannel:(NSString*)channel
{
    PFPush *message = [[PFPush alloc] init];
    [message setChannel:channel];
    [message setData:data];
    [message sendPushInBackground];
}

@end
