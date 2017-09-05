//
//  IGCConstants.h
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 08/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "AppDelegate.h"

#ifndef IGCConstants_h
#define IGCConstants_h

#pragma mark - Macros

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ACTION_SHEET(alertTitle, alertMessage) [UIAlertController alertControllerWithTitle:(alertTitle) message:(alertMessage) preferredStyle:UIAlertControllerStyleActionSheet]
#define ALERT(alertTitle, alertMessage) [UIAlertController alertControllerWithTitle:(alertTitle) message:(alertMessage) preferredStyle:UIAlertControllerStyleAlert]
#define STORYBOARD_CONTROLLER(storyboard, identifier) identifier ? [[UIStoryboard storyboardWithName:(storyboard) bundle:nil] instantiateViewControllerWithIdentifier:(identifier)] : [[UIStoryboard storyboardWithName:(storyboard) bundle:nil] instantiateInitialViewController]

#define APPLICATION [UIApplication sharedApplication]
#define APPLICATION_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define APPLICATION_SINGLETON [IGCAppSingletion sharedInstance]

#define REGISTER_COLLECTION_NIB(collection, identifier) [(collection) registerNib:[UINib nibWithNibName:(identifier) bundle:nil] forCellWithReuseIdentifier:(identifier)];
#define REGISTER_TABLE_NIB(table, identifier) [(table) registerNib:[UINib nibWithNibName:(identifier) bundle:nil] forCellReuseIdentifier:(identifier)];

#define FONT(fontName, fontSize) [UIFont fontWithName:(fontName) size:(fontSize)]
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];
#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#define DOCUMENTS_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define SYSTEM_VERSION_GREATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IS_IPAD (IDIOM == UIUserInterfaceIdiomPad)
#define IS_IPHONE (IDIOM == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#endif /* IGCConstants_h */

#pragma mark - Constants

#pragma mark - Info.plst keys

extern NSString * const kIGCHockeyAppIDInfoPlistKey;

#pragma mark - User Default keys

extern NSString * const kIGCAuthInstanceUserDefaultsKey;
extern NSString * const kIGCDeviceTokenUserDefaultsKey;
