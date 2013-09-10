//
//  TwitterUser.h
//  MyCharityLife
//
//  Created by Mike Holp on 8/20/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TwitterUser : UIViewController<UIWebViewDelegate>

@property(nonatomic,retain) IBOutlet UIWebView *twitterView;

@end
