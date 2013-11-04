//
//  SDCloudUserDefaults.m
//
//  Created by Stephen Darlington on 01/09/2011.
//  Copyright (c) 2011 Wandle Software Limited. All rights reserved.
//

#import "SDCloudUserDefaults.h"

@implementation SDCloudUserDefaults

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
        retv = [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
        [cloud setObject:retv forKey:aKey];
    }
    return retv;
}

+(NSInteger)integerForKey:(NSString*)aKey {
    return [[SDCloudUserDefaults objectForKey:aKey] integerValue];
}

+(void)setString:(NSString*)aString forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:aString forKey:aKey];
}

+(void)setBool:(BOOL)aBool forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:[NSNumber numberWithBool:aBool] forKey:aKey];
}

+(void)setObject:(id)anObject forKey:(NSString*)aKey {
    [[NSUbiquitousKeyValueStore defaultStore] setObject:anObject forKey:aKey];
    [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:aKey];
}

+(void)setInteger:(NSInteger)anInteger forKey:(NSString*)aKey {
    [SDCloudUserDefaults setObject:[NSNumber numberWithInteger:anInteger]
                            forKey:aKey];
}

+(void)removeObjectForKey:(NSString*)aKey {
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:aKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
}

+(void)synchronize {
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NSUbiquitousKeyValueStoreDidChangeExternallyNotification"
                                                      object:[NSUbiquitousKeyValueStore defaultStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification* notification) {
                                                      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                                      NSUbiquitousKeyValueStore* cloud = [NSUbiquitousKeyValueStore defaultStore];
                                                      NSArray* changedKeys = [notification.userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
                                                      for (NSString* key in changedKeys) {
                                                          [defaults setObject:[cloud objectForKey:key] forKey:key];
                                                      }
                                                  }];

}

+(void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:[NSUbiquitousKeyValueStore defaultStore]];
}

@end
