//
//  IGCUtils.h
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 08/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IGCUtils : NSObject

/*!
 * @discussion Retrieves a custom NSObject instance.
 * @param key Key used in storing it to NSUserDefaults.
 * @return A custom NSObject instance
 */
+ (id)getUserDefaultsCustomObjectForKey:(NSString *)key;
/*!
 * @discussion Retrieves a NSObject instance.
 * @param key Key used in storing it to NSUserDefaults.
 * @return A NSObject instance.
 */
+ (id)getUserDefaultsObjectForKey:(NSString *)key;
/*!
 * @discussion Retrieves a value.
 * @param key Key used in storing it to NSUserDefaults.
 * @return The stored value
 */
+ (id)getUserDefaultsValueForKey:(NSString *)key;
/*!
 * @discussion Stores a custom NSObject instance using a key.
 * @param object Custon NSObject instance.
 * @param key Identifier of the instance.
 */
+ (void)setUserDefaultsCustomObject:(__kindof NSObject *)object key:(NSString *)key;
/*!
 * @discussion Stores a NSObject instance using a key.
 * @param object NSObject instance.
 * @param key Identifier of the instance.
 */
+ (void)setUserDefaultsObject:(__kindof NSObject *)object key:(NSString *)key;
/*!
 * @discussion Stores a NSObject instance using a key.
 * @param value Value to be stored
 * @param key Identifier of the instance.
 */
+ (void)setUserDefaultsValue:(id)value key:(NSString *)key;

/*!
 * @discussion Creates a single Core Data store record for a provided entity.
 * @param entityName The name of the entity to be created. Case-sensitve.
 * @return The newly created entity record.
 */
+ (__kindof NSManagedObject *)createRecordForEntity:(NSString *)entityName;
/*!
 * @discussion Fetch a single record given the entity, further filtered by its attributes.
 * @param entityName The name of the entity
 * @return A single NSManagedObject instance
 */
+ (__kindof NSManagedObject *)fetchRecordForEntity:(NSString *)entityName details:(NSDictionary *)detailDict;
/*!
 * @discussion Fetch a collection of records given the entity, further filtered by its attributes.
 * @param entityName The name of the entity
 * @param detailDict Dictionary containing the key-value parameters corresponding the NSManagedObject attributes
 * @return List of NSManagedObject instances
 */
+ (NSArray *)fetchRecordsForEntity:(NSString *)entityName details:(NSDictionary *)detailDict;
/*!
 * @discussion Wherein all additional UI changes is to be implemented
 */
+ (void)setupGlobalUIAdditions;

@end
