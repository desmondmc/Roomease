//
//  HPLoginRouter.m
//  HousePlant
//
//  Created by Desmond McNamee on 1/4/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPLoginRouter.h"
#import "HPNoHomeViewController.h"
#import "HPMainViewController.h"

@implementation HPLoginRouter

+ (UIViewController *)getFirstViewToLoadForUser
{
    PFUser *currentUser = [PFUser currentUser];
    
    PFObject *house = [currentUser objectForKey:@"house"];
    
    if (house) {
        //return main view for the users house
        HPMainViewController *mainViewController = [[HPMainViewController alloc] init];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        return mainViewController;
    }
    else
    {
        HPNoHomeViewController *noHomeViewController = [[HPNoHomeViewController alloc] init];
        noHomeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        return noHomeViewController;
    }
}

@end
