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

@end
