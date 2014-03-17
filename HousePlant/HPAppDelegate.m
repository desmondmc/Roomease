//
//  HPAppDelegate.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/6/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPAppDelegate.h"
#import "HPMainViewController.h"
#import "HPStartingViewController.h"
#import "HPNoHomeViewController.h"

#import "ParseKeys.h"
#import "TestFlight.h"


@implementation HPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:kParseAppId
                  clientKey:kParseClientKey];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [TestFlight takeOff:@"14906e3c-2003-4328-946b-bf7afdbe9b29"];
    
    //[Crashlytics startWithAPIKey:kCrashlyticsKey];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser)
    {
        [[PFUser currentUser] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (currentUser) {
                
                PFObject *house = [currentUser objectForKey:@"home"];
                if (house) {
                    self.window.rootViewController = [[HPMainViewController alloc] init];
                }
                else
                {
                    self.window.rootViewController = [[HPStartingViewController alloc] init];
                }
            }
            else
            {
                self.window.rootViewController = [[HPStartingViewController alloc] init];
            }
            [self.window makeKeyAndVisible];
        }];
    }
    else
    {
        self.window.rootViewController = [[HPStartingViewController alloc] init];
        [self.window makeKeyAndVisible];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#warning Should not be clearing Central Data everytime the app comes into view.
    [HPCentralData clearCentralData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_BECAME_ACTIVE object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"alert"] != nil)
    {
        [PFPush handlePush:userInfo];
    }
    
    NSLog(@"Recieved Push");
    if (![[userInfo objectForKey:@"src_usr"] isEqualToString:[PFUser currentUser].objectId] ) {
        [HPSyncWorker handleSyncRequestWithDictionary:userInfo];
    }
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //Only do this if the user is running 7.0.*.
    if(SYSTEM_VERSION_LESS_THAN(@"7.1"))
    {
        NSDateFormatter *formatter;
        NSString        *dateString;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        
        dateString = [formatter stringFromDate:[NSDate date]];
        [[PFUser currentUser] setObject:dateString forKey:@"keepalive"];
        
        [[PFUser currentUser] save];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
