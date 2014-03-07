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
    PFObject *house = [currentUser objectForKey:@"home"];
    
    if (house) {
        //return main view for the users house
        //[HPCentralData getHouse];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        
        [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
            [currentInstallation addUniqueObjectsFromArray:@[house.houseName, [PFUser currentUser].username] forKey:@"channels"];
            [currentInstallation saveInBackground];
        }];

        
        HPMainViewController *mainViewController = [[HPMainViewController alloc] init];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        return mainViewController;
        return nil;
    }
    else
    {
        HPNoHomeViewController *noHomeViewController = [[HPNoHomeViewController alloc] init];
        noHomeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        return noHomeViewController;
    }
}

@end
