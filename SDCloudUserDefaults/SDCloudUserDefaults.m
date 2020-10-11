//
//  SDCloudUserDefaults.m
//
//  Created by Stephen Darlington on 01/09/2011.
//  Copyright (c) 2011 Wandle Software Limited. All rights reserved.
//

#import "SDCloudUserDefaults.h"

@implementation SDCloudUserDefaults

NSString * const SDCloudValueUpdatedNotification = @"com.wandlesoftware.SDCloudUserDefaults.KeyValueUpdated";

static id notificationObserver;
static NSString *suiteName;
static NSUserDefaults *userDefaults;

+ (void) setiCloudEnabled:(BOOL)iCloudEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:iCloudEnabled forKey:ICLOUD_DATA_ENABLED_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (iCloudEnabled == YES) {
        [SDCloudUserDefaults registerForNotifications];
    } else {
        [SDCloudUserDefaults removeNotifications];
    }
}

+ (BOOL) isiCloudEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ICLOUD_DATA_ENABLED_KEY];
}

+ (void) initialize {
    [super initialize];
    
    id keyValue = [SDCloudUserDefaults objectForKey:ICLOUD_DATA_ENABLED_KEY];
    
    if (keyValue != nil) {
        BOOL iCloudEnabled = [SDCloudUserDefaults boolForKey:ICLOUD_DATA_ENABLED_KEY];
        
        if (iCloudEnabled == YES) {
            [SDCloudUserDefaults registerForNotifications];
        } else {
            [SDCloudUserDefaults removeNotifications];
        }
    }
}

+(NSUserDefaults *) _standardUserDefaults {
    if (userDefaults == nil) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return userDefaults;
}

+(void)setSuiteName:(NSString *)aSuiteName {
    if (suiteName == aSuiteName) {
        return;
    }
#if __has_feature(objc_arc)
    suiteName = aSuiteName;
#else
    [suiteName release];
    suiteName = [aSuiteName copy];
#endif
    if (!suiteName) {
#if !__has_feature(objc_arc)
        [userDefaults release];
#endif
        userDefaults = nil;
    }
    else {
        userDefaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
        NSDictionary *dictionary = [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
        for (NSString *key in [dictionary allKeys]) {
            if (![userDefaults objectForKey:key]) {
                [userDefaults setObject:dictionary[key] forKey:key];
            }
        }
    }
}

+(NSString*)suiteName {
    return suiteName;
}

+(NSString*)stringForKey:(NSString*)aKey {
    return [SDCloudUserDefaults objectForKey:aKey];
}

+(BOOL)boolForKey:(NSString*)aKey {
    return [[SDCloudUserDefaults objectForKey:aKey] boolValue];
}

+(id)objectForKey:(NSString*)aKey {
    if ([SDCloudUserDefaults isiCloudEnabled] == YES) {
        NSUbiquitousKeyValueStore* cloud = [NSUbiquitousKeyValueStore defaultStore];
        id retv = [cloud objectForKey:aKey];
       
        if (!retv) {
            retv = [[self _standardUserDefaults] objectForKey:aKey];
            [cloud setObject:retv forKey:aKey];
        }
        
        return retv;
    } else {
        return [[self _standardUserDefaults] objectForKey:aKey];
    }
}

+(NSInteger)integerForKey:(NSString*)aKey {
    return [[SDCloudUserDefaults objectForKey:aKey] integerValue];
}

+(float)floatForKey:(NSString *)aKey {
    return [[SDCloudUserDefaults objectForKey:aKey] floatValue];
}

+(void)setString:(NSString*)aString forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:aString forKey:aKey];
}

+(void)setBool:(BOOL)aBool forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:[NSNumber numberWithBool:aBool] forKey:aKey];
}

+(void)setObject:(id)anObject forKey:(NSString*)aKey {
    if ([SDCloudUserDefaults isiCloudEnabled] == YES) {
        [[NSUbiquitousKeyValueStore defaultStore] setObject:anObject forKey:aKey];
    }
    
    [[self _standardUserDefaults] setObject:anObject forKey:aKey];
    
    [SDCloudUserDefaults synchronize];
}

+(void)setInteger:(NSInteger)anInteger forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:[NSNumber numberWithInteger:anInteger]
                            forKey:aKey];
}

+(void)setFloat:(float)aFloat forKey:(NSString *)aKey {
    [SDCloudUserDefaults setObject:@(aFloat)
                            forKey:aKey];
}

+(void)removeObjectForKey:(NSString*)aKey {
    if ([SDCloudUserDefaults isiCloudEnabled] == YES) {
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:aKey];
    }
    
    [[self _standardUserDefaults] removeObjectForKey:aKey];
    
    [SDCloudUserDefaults synchronize];
}

+(void)synchronize {
    if ([SDCloudUserDefaults isiCloudEnabled] == YES) {
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
    
    [[self _standardUserDefaults] synchronize];
}

+(void)registerForNotifications {
    @synchronized(notificationObserver) {
        if (notificationObserver) {
            return;
        }

        notificationObserver = [[NSNotificationCenter defaultCenter]
                                addObserverForName:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                object:[NSUbiquitousKeyValueStore defaultStore]
                                queue:nil
                                usingBlock:^(NSNotification* notification) {
                                    
                                    NSDictionary* userInfo = [notification userInfo];
                                    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
                                    
                                    // If a reason could not be determined, do not update anything.
                                    if (!reasonForChange)
                                        return;
                                    
                                    // Update only for changes from the server.
                                    NSInteger reason = [reasonForChange integerValue];
                                    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
                                        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
                                        
                                        NSUserDefaults* defaults = [self _standardUserDefaults];
                                        NSUbiquitousKeyValueStore* cloud = [NSUbiquitousKeyValueStore defaultStore];
                                        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
                                        
                                        for (NSString* key in changedKeys) {
                                            id obj = [cloud objectForKey:key];

                                            [defaults setObject:obj forKey:key];

                                            if (obj != nil) {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:SDCloudValueUpdatedNotification
                                                                                                    object:self
                                                                                                  userInfo:@{key:[cloud objectForKey:key]}];
                                            } else {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:SDCloudValueUpdatedNotification
                                                                                                    object:self
                                                                                                  userInfo:nil];
                                            }
                                        }
                                        
                                        
                                    }
                                }];
    }
    
}

+(void)removeNotifications {
    @synchronized(notificationObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:notificationObserver];
        notificationObserver = nil;
    }
}

@end
