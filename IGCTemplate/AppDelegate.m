//
//  AppDelegate.m
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 08/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <HockeySDK/HockeySDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AppDelegate.h"

#pragma mark - Class Extension

@interface AppDelegate ()

@property (nonatomic, strong) NSString *firebaseToken;

@end

@implementation AppDelegate

#pragma mark - Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IGCUtils setupGlobalUIAdditions];
    
    // Third-party libraries setup
    [self setupHockeyApp];
    [self setupIQKeyboardManager];
    
#if !(TARGET_OS_SIMULATOR)
    if (SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(@"10.0")) {
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        [self setupFirebase];
    }
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Push Notification Setup

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    // Store Device token to User Defaults
    [IGCUtils setUserDefaultsValue:[token copy] key:kIGCDeviceTokenUserDefaultsKey];
    
    // TODO Register Device token to Firebase
//    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeUnknown];
    
    [self registerDeviceToFirebaseAndAPI];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"%@: %@", [self class], error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self processReceivedNotification:userInfo forApplication:application];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(@"10.0")) {
        return;
    }
    
    [self processReceivedNotification:userInfo forApplication:application];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Called when a notification is delivered to a foreground app.
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Called to let your app know which action was selected by the user for a given notification.
    [self translateNotificationContentToUI:response.notification.request.content.userInfo];
}

#pragma mark - Core Data stack (iOS 10)

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"<xcdatamodelid name>"];  // TODO Change to actual name
            
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data stack (iOS 9)

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Your Bundle Indentifier" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    NSURL *modelURL;
    
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    modelURL = [[NSBundle mainBundle] URLForResource:@"<xcdatamodelid name>" withExtension:@"momd"];  // TODO Change to actual name
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSURL *storeURL;
    NSError *error = nil;
    NSString *failureReason;
    
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"<xcdatamodelid name>.sqlite"];  // TODO Change to actual name
    error = nil;
    failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSPersistentStoreCoordinator *coordinator;
    
    if (SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(@"10.0")) {
        if (!self.persistentContainer) {
            return nil;
        }
        
        return self.persistentContainer.viewContext;
    }
    
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    coordinator = [self persistentStoreCoordinator];
    
    if (!coordinator) {
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    if (SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(@"10.0")) {
        NSManagedObjectContext *context = self.persistentContainer.viewContext;
        NSError *error = nil;
        
        if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        }
    } else {
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        
        if (managedObjectContext != nil) {
            NSError *error = nil;
            
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
    }
}

#pragma mark - Protocol Methods (Firebase)
/*
  // Implement Firebase protocol methods
 
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    DLog(@"FCM data message: %@", remoteMessage.appData);
}
 
- (void)messaging:(FIRMessaging *)messaging didRefreshRegistrationToken:(NSString *)fcmToken {
    self.firebaseToken = fcmToken;
 
    DLog(@"Refreshed Firebase token: %@", self.firebaseToken);
 
    [self registerDeviceToFirebaseAndAPI];
}
*/
#pragma mark - Private Methods

- (void)processReceivedNotification:(NSDictionary *)userInfo forApplication:(UIApplication *)application {
    if (userInfo && [userInfo objectForKey:@"collapse_key"]) {
        return;
    }
    
    if (application.applicationState == UIApplicationStateActive ||
        application.applicationState == UIApplicationStateBackground ||
        application.applicationState == UIApplicationStateInactive) {
        
        switch (application.applicationState) {
            case UIApplicationStateActive:
                // TODO Display banner/UI updates
                
                break;
            default:
                break;
        }
    }
}

- (void)setupFirebase {
    // NOTE Uncomment if Firebase is already setup
    
//    [FIRApp configure];
//    
//    if ([FIRMessaging messaging].FCMToken) {
//        self.firebaseToken = [FIRMessaging messaging].FCMToken;
//    }
//    
//    DLog(@"Firebase token: %@", self.firebaseToken);
//    
//    [FIRMessaging messaging].delegate = self;
}

- (void)setupHockeyApp {
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:kIGCHockeyAppIDInfoPlistKey];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:identifier];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

- (void)setupIQKeyboardManager {
    IQKeyboardManager *keyboardManager;
    
    keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.keyboardDistanceFromTextField = 10;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

- (void)translateNotificationContentToUI:(NSDictionary *)userInfo {
    // TODO UI updates base on notification data
}

#pragma mark - Public Methods

- (void)registerDeviceToFirebaseAndAPI {
    NSString *deviceToken = [IGCUtils getUserDefaultsValueForKey:kIGCDeviceTokenUserDefaultsKey];
    NSString *deviceId = FORMAT(@"%@ %@:%@",
                                [UIDevice currentDevice].systemName,
                                [UIDevice currentDevice].systemVersion,
                                deviceToken);
    
    DLog(@"Device ID: %@", deviceId);
    
    if (!self.firebaseToken || !deviceToken) {
        return;
    }
    
    // TODO Send unique device token to API
}

- (void)registerForRemoteNotifications {
    if (SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions authorizationOptions = (UNAuthorizationOptionSound |
                                                       UNAuthorizationOptionAlert |
                                                       UNAuthorizationOptionBadge);
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                return;
            }
            
            [APPLICATION registerForRemoteNotifications];
        }];
    } else {  // For iOS 9 and earlier
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert |
                                                       UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes
                                                                                 categories:nil];
        
        [APPLICATION registerUserNotificationSettings:settings];
        [APPLICATION registerForRemoteNotifications];
    }
}

- (void)triggerRegisterForNotifications {
    UIUserNotificationSettings *settings = [APPLICATION currentUserNotificationSettings];
    NSString *deviceToken = [IGCUtils getUserDefaultsValueForKey:kIGCDeviceTokenUserDefaultsKey];
    
    if (([APPLICATION isRegisteredForRemoteNotifications] || settings.types & UIUserNotificationTypeAlert) &&
        (deviceToken && deviceToken.length > 0)) {
        [self registerDeviceToFirebaseAndAPI];
    } else {
        [self registerForRemoteNotifications];
    }
}

@end
