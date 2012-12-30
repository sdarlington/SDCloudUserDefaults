//
//  SDCloudUserDefaults.h
//
//  Created by Stephen Darlington on 01/09/2011.
//  Copyright (c) 2011 Wandle Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCloudUserDefaults : NSObject

+(NSString*)stringForKey:(NSString*)aKey;
+(BOOL)boolForKey:(NSString*)aKey;
+(id)objectForKey:(NSString*)aKey;
+(NSInteger)integerForKey:(NSString*)aKey;

+(void)setString:(NSString*)aString forKey:(NSString*)aKey;
+(void)setBool:(BOOL)aBool forKey:(NSString*)aKey;
+(void)setObject:(id)anObject forKey:(NSString*)aKey;
+(void)setInteger:(NSInteger)anInteger forKey:(NSString*)aKey;

+(void)removeObjectForKey:(NSString*)aKey;

+(void)synchronize;

+(void)registerForNotifications;
+(void)removeNotifications;

@end
