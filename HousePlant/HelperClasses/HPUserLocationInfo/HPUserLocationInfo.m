//
//  HPUserLocationInfo.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/15/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPUserLocationInfo.h"

@implementation HPUserLocationInfo

-(id)initWithAtHome:(bool)atHome {
    if (self = [super init]) {
        _atHome = atHome;
    }
    return self;
}

@end
