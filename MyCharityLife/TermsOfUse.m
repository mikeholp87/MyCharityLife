//
//  TermsOfUse.m
//  MyCharityLife
//
//  Created by Michael Holp on 6/28/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "TermsOfUse.h"

@implementation TermsOfUse
@synthesize agreeTerms;

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
	
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.mycharitylife.com/privacy-policy.php"]];
    [agreeTerms loadRequest:requestObj];
}

@end
