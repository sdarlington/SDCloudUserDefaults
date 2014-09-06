//
//  SDCloudUserDefaults.h
//
//  Created by Stephen Darlington on 01/09/2011.
//  Copyright (c) 2011-2014 Wandle Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 SDCloudUserDefaults allows you to store values in `NSUserDefaults` and the iCloud key-value store at the same time.
 */

@interface SDCloudUserDefaults : NSObject

/**
 *  A suite can be used to hold preferences that are shared between multiple applications or an application and its extensions.
 *
 *  @param suiteName The suite name to use when accessing and storing local preferences. Set to nil to revert to [NSUserDefaults standardUserDefaults].
 */
+(void)setSuiteName:(NSString *)suiteName;

/**
 *  A suite can be used to hold preferences that are shared between multiple applications or an application and its extensions.
 *
 *  @return The suite name currently being used when accessing and storing local preferences. nil means that it is using [NSUserDefaults standardUserDefaults].
 */
+(NSString*)suiteName;

/**
 *  Returns the string associated with the specified key.
 *
 *  @param aKey A key in the current user's defaults database.
 *
 *  @return The string if one exists; otherwise nil is returned.
 */
+(NSString*)stringForKey:(NSString*)aKey;

/**
 *  Returns the boolean associated with the specified key.
 *
 *  @param aKey A key in the current user's defaults database.
 *
 *  @return The BOOL if one exists; otherwise NO is returned.
 */
+(BOOL)boolForKey:(NSString*)aKey;

/**
 *  Returns the object associated with the specified key
 *
 *  @param aKey A key in the current user's default database.
 *
 *  @return The object if one exists; otherwise nil is returned.
 */
+(id)objectForKey:(NSString*)aKey;

/**
 *  Retuens the the integer associated with the specified key.
 *
 *  @param aKey A key in the current user's defaults database.
 *
 *  @return The NSInteger if one exists; otherwise 0 is returned.
 */
+(NSInteger)integerForKey:(NSString*)aKey;

/**
 *  Returns the float associated with the specified key.
 *
 *  @param aKey A key in the current user's defaults database.
 *
 *  @return the fload if one exists; otherwise 0.0f is returned.
 */
+(float)floatForKey:(NSString*)aKey;

/**
 *  Sets the value of the specified default key in the current application domain.
 *
 *  @param aString The value to store
 *  @param aKey    The key with which to associate with the value.
 */
+(void)setString:(NSString*)aString forKey:(NSString*)aKey;

/**
 *  Sets the value of the specified default key in the current application domain.
 *
 *  @param aBool The value to store
 *  @param aKey  The key with which to associate with the value.
 */
+(void)setBool:(BOOL)aBool forKey:(NSString*)aKey;

/**
 *  Sets the value of the specified default key in the current application domain.
 *
 *  @param anObject The value to store
 *  @param aKey     The key with which to associate with the value.
 */
+(void)setObject:(id)anObject forKey:(NSString*)aKey;

/**
 *  Sets the value of the specified default key in the current application domain.
 *
 *  @param anInteger The value to store
 *  @param aKey      The key with which to associate with the value.
 */
+(void)setInteger:(NSInteger)anInteger forKey:(NSString*)aKey;

/**
 *  Sets the value of the specified default key in the current application domain.
 *
 *  @param aFloat The value to store
 *  @param aKey   The key with which to associate with the value.
 */
+(void)setFloat:(float)aFloat forKey:(NSString*)aKey;

/**
 *  Removes the value of the specified default key in the current application domain.
 *
 *  @param aKey The key of the value to be removed.
 */
+(void)removeObjectForKey:(NSString*)aKey;

/**
 *  Writes any modifications to local storage. This does not guarantee that changes will be written to iCloud.
 */
+(void)synchronize;

/**
 *  Enables SDCloudUserDefaults to automatically receieve updated values from iCloud. This should typically be called as the application starts.
 */
+(void)registerForNotifications;

/**
 *  Stops listening for updated values from iCloud.
 */
+(void)removeNotifications;

@end
