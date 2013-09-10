//
//  TwitterUser.m
//  MyCharityLife
//
//  Created by Mike Holp on 8/20/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "TwitterUser.h"

@implementation TwitterUser
@synthesize twitterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.twitter.com/%@", self.title]]];
        [twitterView loadRequest:requestObj];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
