//
//  AppDelegate.m
//  MyCharityLife
//
//  Created by Michael Holp on 6/26/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "AppDelegate.h"

NSString *const SCSessionStateChangedNotification = @"com.flash.MyCharityLife:FBSessionStateChangedNotification";

@implementation AppDelegate
@synthesize viewController = _viewController;
@synthesize session = _session;
@synthesize window = _window;
@synthesize navController = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSLog(@"In fallback handler");
    }];
}

@end
