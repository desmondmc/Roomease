//
//  HPRoommate.h
//  RoomEase
//
//  Created by Desmond McNamee on 1/28/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPRoommate : HPNetworkObject

+(NSNumber *) boolWithString:(NSString *)string;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) UIImage *profilePic;
@property (strong, nonatomic) NSString *atHomeString;

@end
