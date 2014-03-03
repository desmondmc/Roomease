//
//  HPUINotifier.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/26/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPUINotifier.h"
#import "HPUINotifierDelegate.h"

@implementation HPUINotifier
{
    /**Array of delegates that are subscribing to UI updates.**/
    NSMutableArray *_delegates;
}

+ (id)sharedUINotifier {
    static HPUINotifier *sharedUINotifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUINotifier = [[self alloc] init];
    });
    return sharedUINotifier;
}

- (id)init {
    if (self = [super init]) {
        _delegates = [[NSMutableArray alloc] init];
    }
    return self;
}



-(void) notifyDelegatesWithChange:(NSDictionary *)uiChanges
{
    for (id <HPUINotifierDelegate> delegate in _delegates) {
        [delegate resyncUIWithDictionary:uiChanges];
    }
}


-(void) addDelegate:(id)delegate
{
    if ([delegate conformsToProtocol:@protocol(HPUINotifierDelegate)])
    {
        [_delegates addObject:delegate];
    }
    else
    {
        [NSException raise:@"Invalid delegate sent" format:@"delegate does not implement HPUINotifierDelegate"];
    }
}


@end

