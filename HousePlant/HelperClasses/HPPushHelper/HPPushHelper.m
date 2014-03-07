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
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        //
        [[PFUser currentUser] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            //
            PFQuery *query = [PFInstallation query];
            [query whereKey:@"channels" equalTo:house.houseName];
            [query whereKey:@"channels" notEqualTo:[PFUser currentUser].username];
            
            PFPush *message = [[PFPush alloc] init];
            
            NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:data];
            if (alert != nil) {
                [newDict setValue:alert forKey:@"alert"];
            }
            
            [message setQuery:query];
            [message setData:newDict];
            [message sendPushInBackground];
        }];
    }];
}

@end