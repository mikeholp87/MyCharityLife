//
//  NewsDetail.m
//  MyCharityLife
//
//  Created by Mike Holp on 8/4/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "NewsDetail.h"

@implementation NewsDetail
@synthesize webView, tweetURL;

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
	
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:tweetURL];
    [webView loadRequest:requestObj];
}

@end
