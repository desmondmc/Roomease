//
//  HPRoommate.h
//  RoomEase
//
//  Created by Desmond McNamee on 1/28/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPRoommate : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) UIImage *profilePic;
@property BOOL atHome;

@end
