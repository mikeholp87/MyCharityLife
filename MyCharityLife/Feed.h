//
//  MyFeed.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/23/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "TwitterUser.h"

@interface Feed : UIViewController<FBFriendPickerDelegate, UITableViewDataSource, UITabBarDelegate>
{
    BOOL following, followers;
}

@property(nonatomic,retain) IBOutlet UITableView *feedTable;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segControl;

@property (nonatomic, strong) IBOutlet UITableView *FBFriendListTableView;
@property (strong, nonatomic) NSArray *FBFriendsArray;

@property(strong,nonatomic) NSArray *TwitterArray;
@property(nonatomic,retain) NSUserDefaults *settings;
@property(nonatomic,retain) NSMutableDictionary *twitterInfo;
@property(nonatomic,retain) NSMutableDictionary *facebookInfo;

@end
