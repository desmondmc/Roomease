//
//  FileTypeCell.m
//  bcc interface
//
//  Created by Mohan Krishna Vemulapali on 2013-09-05.
//  Copyright (c) 2013 LiveQoS. All rights reserved.
//

#import "RoommateImageSubview.h"
#import "SingleRoommateSubview.h"

@implementation RoommateImageSubview

+ (id)roommateImageSubview
{
    RoommateImageSubview *subView = [[[NSBundle mainBundle] loadNibNamed:@"RoommateImageSubview" owner:nil options:nil] lastObject];
    


    [[subView rm1Label] setHidden:true];
    [[subView rm1Image] setHidden:true];
    [[subView rm2Label] setHidden:true];
    [[subView rm2Image] setHidden:true];
    [[subView rm3Label] setHidden:true];
    [[subView rm3Image] setHidden:true];
    [[subView rm4Label] setHidden:true];
    [[subView rm4Image] setHidden:true];
    [[subView loadingRoommatesSpinner] setHidden:false];
    
#warning This should be done in the background.
//    [HPCentralData getRoommatesInBackgroundWithBlock:^(NSArray *roommates, NSError *error) {
//        [[subView loadingRoommatesSpinner] setHidden:true];
//        [self setupImagesWithRoomate:roommates andSubview:subView];
//    }];
    
    NSArray *roommates = [HPCentralData getRoommates];
    [[subView loadingRoommatesSpinner] setHidden:true];
    [self setupImagesWithRoomate:roommates andSubview:subView];
    // make sure RoommateImageSubview is not nil or the wrong class!
    if ([subView isKindOfClass:[RoommateImageSubview class]])
        return subView;
    else
        return nil;
}

+ (void) setupImagesWithRoomate:(NSArray *)roommates andSubview:(RoommateImageSubview *)subView
{
    int roommatesCount = [roommates count];
    SingleRoommateSubview *singleRoommateView;
    
    if (roommatesCount >= 1)
    {
        //do stuff
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:0]];
        singleRoommateView.frame = CGRectMake(0, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    
    if (roommatesCount >= 2)
    {
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:1]];
        singleRoommateView.frame = CGRectMake(80, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    
    if (roommatesCount >= 3)
    {
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:2]];
        singleRoommateView.frame = CGRectMake(160, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    
    if (roommatesCount >= 4)
    {
        singleRoommateView = [SingleRoommateSubview initSingleRoommateSubviewWithRoommate:[roommates objectAtIndex:3]];
        singleRoommateView.frame = CGRectMake(240, 0, singleRoommateView.frame.size.width, singleRoommateView.frame.size.height);
        [subView addSubview:singleRoommateView];
    }
    
    if (roommatesCount > 4) {
        NSLog(@"House has more than 4 roommates. This is currently not supported.");
    }
}

+(int)getFrameOffsetWithNumberOfUsers:(int)numberOfUsers
{
    if (numberOfUsers > 4)
    {
#warning we don't support more than 4 users yet.
        return 0;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    return width/(numberOfUsers + 1);
}

@end
