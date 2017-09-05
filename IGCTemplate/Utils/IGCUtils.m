//
//  IGCUtils.m
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 08/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "IGCUtils.h"

@implementation IGCUtils

#pragma mark - NSUserDefaults Helper Methods

+ (id)getUserDefaultsCustomObjectForKey:(NSString *)key {
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    __kindof NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    return object;
}

+ (id)getUserDefaultsObjectForKey:(NSString *)key {
    return [USER_DEFAULTS objectForKey:key];
}

+ (id)getUserDefaultsValueForKey:(NSString *)key {
    return [USER_DEFAULTS valueForKey:key];
}

+ (void)setUserDefaultsCustomObject:(__kindof NSObject *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    [USER_DEFAULTS setObject:encodedObject forKey:key];
    [USER_DEFAULTS synchronize];
}

+ (void)setUserDefaultsObject:(__kindof NSObject *)object key:(NSString *)key {
    [USER_DEFAULTS setObject:object forKey:key];
    [USER_DEFAULTS synchronize];
}

+ (void)setUserDefaultsValue:(id)value key:(NSString *)key {
    [USER_DEFAULTS setValue:value forKey:key];
    [USER_DEFAULTS synchronize];
}

#pragma mark - Core Data Helper Method

+ (__kindof NSManagedObject *)createRecordForEntity:(NSString *)entityName {
    NSError *error = nil;
    NSManagedObjectContext *context = APPLICATION_DELEGATE.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entityDescription
                                       insertIntoManagedObjectContext:context];
    
    [context save:&error];
    
    return !error ? object : nil;
}

+ (__kindof NSManagedObject *)fetchRecordForEntity:(NSString *)entityName details:(NSDictionary *)detailDict {
    NSArray *fetchedObjects = [[self class] fetchRecordsForEntity:entityName details:detailDict];
    
    return fetchedObjects && fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+ (NSArray *)fetchRecordsForEntity:(NSString *)entityName details:(NSDictionary *)detailDict {
    NSString *predicateString = @"";
    NSManagedObjectContext *context = APPLICATION_DELEGATE.managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    for (int i = 0; i < detailDict.allKeys.count; i++) {
        NSString *key = detailDict.allKeys[i];
        NSString *singleConditionString = [NSString stringWithFormat:@"%@ == %@", key, detailDict[key]];
        
        if (i == 0) {
            predicateString = singleConditionString;
        } else {
            predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, singleConditionString];
        }
    }
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - App-wide Helper Method

+ (NSDictionary *)dictionaryFromJSONFile:(NSString *)filename {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:nil];
}

+ (void)setupGlobalUIAdditions {
    // TODO Implementation for all UI additions that reflects globally
    //      e.g. When using the `appearance` attribute of a UIObject
}

@end
