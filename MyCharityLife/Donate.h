//
//  Donate.h
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/13/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DwollaOAuth2Client.h"
#import "IDwollaMessages.h"
#import "DwollaViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface Donate : UIViewController<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate, IDwollaMessages>

@property(nonatomic, retain) IBOutlet UITableView *amountsTable;
@property(strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property(strong, nonatomic) id<FBGraphUser> loggedInUser;

@property(nonatomic, retain) NSUserDefaults *settings;

@property(nonatomic, retain) NSArray *amounts;

@property(nonatomic, retain) DwollaAPI *dwollaAPI;

@end
