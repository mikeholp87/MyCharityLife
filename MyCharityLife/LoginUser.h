//
//  LoginUser.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/21/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LBFacebook.h"
#import "STTwitterAPIWrapper.h"

@interface LoginUser : UIViewController<FBLoginViewDelegate>
@property(nonatomic,retain) IBOutlet UIButton *facebookBtn;
@property(nonatomic,retain) IBOutlet UIButton *twitterBtn;
@property(nonatomic,retain) IBOutlet UIButton *emailBtn;

@property(nonatomic,retain) NSUserDefaults *settings;
@property(nonatomic,retain) NSMutableDictionary *twitterInfo;
@property(nonatomic,retain) NSMutableDictionary *facebookInfo;

@property(nonatomic,retain) LBFacebook *facebook;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property(nonatomic,retain) IBOutlet FBLoginView *loginView;

@end
