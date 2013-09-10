//
//  FindCharities.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/29/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "FindCharities.h"

@implementation FindCharities
@synthesize nextBtn;

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
    
    [nextBtn useWhiteActionSheetStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
