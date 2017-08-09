//
//  AppDelegate.h
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 08/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import <Firebase/Firebase.h>
//#import <FirebaseMessaging/FirebaseMessaging.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
//@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate>  // TODO Interchange once Firebase is already installed

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)registerDeviceToFirebaseAndAPI;
- (void)registerForRemoteNotifications;
- (void)saveContext;
- (void)triggerRegisterForNotifications;

@end

