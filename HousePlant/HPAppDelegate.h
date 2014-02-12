//
//  HPAppDelegate.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/6/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPMainViewController.h"

@interface HPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, atomic)              HPLocationManager *locationManager;
@property (strong, atomic)              HPMainViewController *mainViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
