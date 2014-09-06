//
//  SDCloudUserDefaults.m
//
//  Created by Stephen Darlington on 01/09/2011.
//  Copyright (c) 2011 Wandle Software Limited. All rights reserved.
//

#import "SDCloudUserDefaults.h"

@implementation SDCloudUserDefaults

static id notificationObserver;
static NSString *suiteName;
static NSUserDefaults *userDefaults;

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
    NSUbiquitousKeyValueStore* cloud = [NSUbiquitousKeyValueStore defaultStore];
    id retv = [cloud objectForKey:aKey];
    if (!retv) {
        retv = [[self _standardUserDefaults] objectForKey:aKey];
        [cloud setObject:retv forKey:aKey];
    }
    return retv;
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
    [[NSUbiquitousKeyValueStore defaultStore] setObject:anObject forKey:aKey];
    [[self _standardUserDefaults] setObject:anObject forKey:aKey];
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
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:aKey];
    [[self _standardUserDefaults] removeObjectForKey:aKey];
}

+(void)synchronize {
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    [[self _standardUserDefaults] synchronize];
}

+(void)registerForNotifications {
    @synchronized(notificationObserver) {
        if (notificationObserver) {
            return;
        }

        notificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"NSUbiquitousKeyValueStoreDidChangeExternallyNotification"
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
                                                                                         [defaults setObject:[cloud objectForKey:key] forKey:key];
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
