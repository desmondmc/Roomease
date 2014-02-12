//
//  FileTypeCell.m
//  bcc interface
//
//  Created by Mohan Krishna Vemulapali on 2013-09-05.
//  Copyright (c) 2013 LiveQoS. All rights reserved.
//

#import "RoommateImageSubview.h"

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
    int roommatesCount = [roommates count];
    
    if (roommatesCount >= 1)
    {
        //do stuff
        [[subView rm1Label] setText:[((HPRoommate *)[roommates objectAtIndex:0]) username]];
        [[subView rm1Label] setHidden:false];
        [[subView rm1Image] setHidden:false];
    }
    
    if (roommatesCount >= 2)
    {
        //do stuff
        [[subView rm2Label] setText:[((HPRoommate *)[roommates objectAtIndex:1]) username]];
        [[subView rm2Label] setHidden:false];
        [[subView rm2Image] setHidden:false];
    }
    
    if (roommatesCount >= 3)
    {
        //do stuff
        [[subView rm3Label] setText:[((HPRoommate *)[roommates objectAtIndex:2]) username]];
        [[subView rm3Label] setHidden:false];
        [[subView rm3Image] setHidden:false];
    }
    
    if (roommatesCount >= 4)
    {
        //do stuff
        [[subView rm4Label] setText:[((HPRoommate *)[roommates objectAtIndex:3]) username]];
        [[subView rm4Label] setHidden:false];
        [[subView rm4Image] setHidden:false];
    }
    
    if (roommatesCount > 4) {
        NSLog(@"House has more than 4 roommates. This is currently not supported.");
    }

}

@end
