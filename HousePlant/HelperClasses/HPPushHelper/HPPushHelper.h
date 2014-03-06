//
//  HPPushHelper.h
//  RoomEase
//
//  Created by Gregory Flatt on 3/5/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPPushHelper : NSObject

+ (void)sendNotificationWithMessage:(NSString*)message toChannel:(NSString*)channel;

+ (void)sendNotificationWithData:(NSDictionary *)data toChannel:(NSString*)channel andAlert:(NSString *)alert;


@end
