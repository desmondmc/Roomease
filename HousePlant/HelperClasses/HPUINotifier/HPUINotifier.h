//
//  HPUINotifier.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/26/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPUINotifier : NSObject

+ (id)sharedUINotifier;

-(void) notifyDelegatesWithChange:(NSDictionary *)uiChanges;

-(void) addDelegate:(id)delegate;

@end
