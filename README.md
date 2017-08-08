### What is this repository for? ###

This repository is where the iOS mobile project template used by **JumpStart** is stored.

### How do I get set up? ###
##### Summary of set up #####
The following are the configurations already handled within the project:

* Installation of Pods
   * HockeyApp
   * IQKeyboardManager
   * JSONModel
* Constants and Util files
* Push Notifications setup
* Project Directory and File Directory structure already prepared
* Fastlane

##### Update project template #####
After cloning this template, you need to update you Bundle ID to conform to your project specifications. Also, add your preferred prefix to the Project settings so that files created afterwards will be distinct based on the prefix of choice. Renaming the project itself is advised, but take note, doing so will affect the project as a whole. Implications such as needing to add all of the associated files to the project again is to be expected.

##### Dependencies #####
Here are some of the dependencies you need to cater to be able to fully use the project template:

* ###### Fastlane ######
   * In your **fastlane/AppFile**:
      * Fill in `app_identifier` with your project's bundle ID.
   * In your **fastlane/Fastfile**:
      * Fill in `ENV["XCODE_PROJECT"]` with your project's .xcodeproj filename.
      * Fill in `ENV["HOCKEYAPP_API_TOKEN"]` with your project's HockeyApp API token.

* ###### Firebase ######
   * Only the setup methods for Firebase has been included in the app. To complete its integration, you need to install the ff. SDKs from **Cocoapods**:
      * `pod 'Firebase'`
      * `pod 'FirebaseMessaging'`
   * After installing aforementioned SDKs, follow the steps provided in the  [Setting Up a Firebase Cloud Messaging Client App on iOS](https://firebase.google.com/docs/cloud-messaging/ios/client) instruction link to complete the process.
   * In the `AppDelegate.m` file: 
      * Uncomment the contents of the `- (void)setupFirebase` method.
      * Uncomment the methods within the `#pragma mark - Protocol Methods (Firebase)`.
      * Uncomment the single commented line in the `- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken` method.

* ###### HockeyApp ######
   * In order to complete the HockeyApp setup:
      * Open the `Info.plist` file.
      * Fill in your project's HockeyApp App ID file in the `IGCHockeyAppID` property.
