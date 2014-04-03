//
//  FileTypeCell.m
//  bcc interface
//
//  Created by Mohan Krishna Vemulapali on 2013-09-05.
//  Copyright (c) 2013 LiveQoS. All rights reserved.
//

#import "RoommateImageSubview.h"
#import "SingleRoommateSubview.h"
#import "HPUINotifier.h"

@implementation RoommateImageSubview

+ (id)initRoommateImageSubview
{
    RoommateImageSubview *subView = [[[NSBundle mainBundle] loadNibNamed:@"RoommateImageSubview" owner:nil options:nil] lastObject];
    
    [[HPUINotifier sharedUINotifier] addDelegate:subView];
    
    [[subView loadingRoommatesSpinner] setHidden:false];
    
    [HPCentralData getRoommatesInBackgroundWithBlock:^(NSArray *roommates, NSError *error) {
        [[subView loadingRoommatesSpinner] setHidden:true];
        [self setupImagesWithRoomate:roommates andSubview:subView];
    }];

    // make sure RoommateImageSubview is not nil or the wrong class!
    if ([subView isKindOfClass:[RoommateImageSubview class]])
        return subView;
    else
        return nil;
}

+ (void) setupImagesWithRoomate:(NSArray *)roommates andSubview:(RoommateImageSubview *)subView
{
    NSInteger roommatesCount = [roommates count];
    SingleRoommateSubview *singleRoommateView;
    
    if (roommatesCount == 1)
    {
        //do stuff
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:0]];
        singleRoommateView.frame = CGRectMake(120, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    else if (roommatesCount == 2)
    {
        //do stuff
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:0]];
        singleRoommateView.frame = CGRectMake(67, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:1]];
        singleRoommateView.frame = CGRectMake(174, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
    }
    else if (roommatesCount == 3)
    {
        //do stuff
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:0]];
        singleRoommateView.frame = CGRectMake(40, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:1]];
        singleRoommateView.frame = CGRectMake(120, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:2]];
        singleRoommateView.frame = CGRectMake(200, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    else if (roommatesCount == 4)
    {
        //do stuff
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:0]];
        singleRoommateView.frame = CGRectMake(0, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:1]];
        singleRoommateView.frame = CGRectMake(80, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:2]];
        singleRoommateView.frame = CGRectMake(160, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
        
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:3]];
        singleRoommateView.frame = CGRectMake(240, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    
    else {
        NSLog(@"House has more than 4 roommates. This is currently not supported.");
    }
}

#warning we should have functions in here for updating, adding and removing roommates in here.

-(void) resyncUIWithDictionary:(NSDictionary *)uiChanges
{
   if ([[uiChanges objectForKey:kRefreshRoommatesKey] boolValue] == YES)
   {
#warning this is the entry point. Idealy here we only update the information we have to. This will mean sending more information along with the resync dictionary.
       if (true) {
           [HPCentralData getRoommatesInBackgroundWithBlock:^(NSArray *roommates, NSError *error) {

               [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
               
               [RoommateImageSubview setupImagesWithRoomate:roommates andSubview:self];
           }];
       }
       else
       {
           
       }
   } 
}



@end
