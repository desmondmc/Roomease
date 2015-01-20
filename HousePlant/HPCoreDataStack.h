//
//  HPCoreDataStack.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-20.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPCoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
