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
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:data];
    if (alert != nil) {
        [newDict setValue:alert forKey:@"alert"];
    }
    
    [PFCloud callFunctionInBackground:@"sendPushToMates"
                       withParameters:@{@"data": newDict}
                                block:^(NSString *channelName, NSError *error) {
                                   
                                }];

//    [[PFUser currentUser] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        [HPCentralData getRoommatesInBackgroundWithBlock:^(NSArray *roommates, NSError *error) {
//            //
//            for (HPRoommate *roommate in roommates) {
//                if (![[roommate username] isEqualToString:[PFUser currentUser].username]) {
//                    PFQuery *query = [PFInstallation query];
//                    [query whereKey:@"channels" equalTo:roommate.username];
//                    
//                    PFPush *message = [[PFPush alloc] init];
//                    
//                    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:data];
//                    if (alert != nil) {
//                        [newDict setValue:alert forKey:@"alert"];
//                    }
//                    
//                    [message setQuery:query];
//                    [message setData:newDict];
//                    [message sendPushInBackground];
//                }
//            }
//        }];
//    }];
}

+ (void)newUserAddedToHouseNowSetupPushChannels
{
    //The following sets up all the users with their respective channels. This includes users who are already part of the house.
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        
        //Add the house name and all the usernames as channels for this user and users already in the house.
        //Now that everyone in the house has the new user's username channel we need to create the channels for the new user.
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObjectsFromArray:@[house.houseName] forKey:@"channels"];
        [currentInstallation saveEventually];
    }];
}

@end
