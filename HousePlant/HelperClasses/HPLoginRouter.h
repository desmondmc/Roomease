//
//  HPLoginRouter.h
//  HousePlant
//
//  Created by Desmond McNamee on 1/4/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPLoginRouter : NSObject

//Checks the currently logged in user and returns the view that they should see after login.
+ (UIViewController *)getFirstViewToLoadForUser;

@end
