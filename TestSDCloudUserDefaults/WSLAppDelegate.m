//
//  WSLAppDelegate.m
//  TestSDCloudUserDefaults
//
//  Created by Stephen Darlington on 30/12/2012.
//  Copyright (c) 2012 Wandle Software Limited. All rights reserved.
//

#import "WSLAppDelegate.h"
#import "SDCloudUserDefaults.h"

@implementation WSLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SDCloudUserDefaults registerForNotifications];
    return YES;
}

@end
