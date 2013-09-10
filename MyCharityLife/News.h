//
//  News.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/15/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MBProgressHUD.h"
#import "STTwitterAPIWrapper.h"
#import "NewsDetail.h"

@interface News : UIViewController

@property(nonatomic,retain) IBOutlet UITableView *newsTable;
@property(nonatomic,retain) ACAccountStore *accountStore;
@property(nonatomic,retain) NSMutableDictionary *tweets;
@property(nonatomic,retain) NSUserDefaults *settings;
@property(nonatomic,retain) NSMutableDictionary *twitterInfo;

@end
