//
//  HPUser.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/12/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPUser.h"
#import <Parse/Parse.h>

@implementation HPUser

+ (HPUser *) loginUserWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [PFUser logInWithUsername:username password:password];
    return [self getLoggedInUser];
}

+ (HPUser *) getLoggedInUser
{
    HPUser *user = [[HPUser alloc] init];
    user.username = [PFUser currentUser].username;
    //TODO this HPUser should have everything a PFUser has.
    return user;
}

- (BOOL) logoutCurrentUser
{
    [PFUser logOut];
    return true;
}

@end
