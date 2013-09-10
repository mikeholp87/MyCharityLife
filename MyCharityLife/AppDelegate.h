//
//  AppDelegate.h
//  MyCharityLife
//
//  Created by Michael Holp on 6/26/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const SCSessionStateChangedNotification;

@class LoginUser;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) LoginUser *viewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@end
