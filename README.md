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
* API client
* Push Notifications setup
* Project Directory and File Directory structure already prepared
* Fastlane
* Template files for `UIViewController` and `UITableViewCell`

##### Usage #####
To be able to utilize this template, you would need to clone this repository to your preferred project directory. Building the project should produce no errors.

After cloning this template, you need to update you Bundle ID to conform to your project specifications. Also, add your preferred prefix to the Project settings so that files created afterwards will be distinct based on the prefix of choice. 

Renaming the project itself is advised to conform with your project name, but doing so will affect the project as a whole. Implications such as needing to add all of the associated files to the project again, connecting it back to Xcode project, among other issues is to be expected. Template files need not to be renamed. Luckily, Xcode can handle project name change, covering most, if not all of the important project files, and updating the configuration of the project to cater the change. Further details will be provided in the **Migration** section.

Template files for `UIViewController` and `UITableViewCell` are also provided. This should be used as a superclass for your subsequent `UIViewController` and `UITableViewCell` instances for it already has methods and attributes needed for its usage.

##### Migration to your project #####
Full instructions on how to update project template for own usage can be found in this [document](https://docs.google.com/document/d/1dLdOU4iAb-WWX6yCqoXAP95LiGj5VsmAE9YLxLdwg4c/edit).

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
* Uncomment the `#import` lines corresponding to Firebase in the `AppDelegate.h` file

* ###### HockeyApp ######
* In order to complete the HockeyApp setup:
* Open the `Info.plist` file.
* Fill in your project's HockeyApp App ID file in the `IGCHockeyAppID` property.
