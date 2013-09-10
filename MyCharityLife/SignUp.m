//
//  SignUp.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/22/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "SignUp.h"

@implementation SignUp

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
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)signupFacebook:(id)sender
{
    UITabBarController *mainTab = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
    [self presentViewController:mainTab animated:YES completion:nil];
}

- (IBAction)signupTwitter:(id)sender
{
    Email *emailView = [self.storyboard instantiateViewControllerWithIdentifier:@"Email"];
    emailView.title = @"Twitter Signup";
    [self.navigationController pushViewController:emailView animated:YES];
}

- (IBAction)signupEmail:(id)sender
{
    Email *emailView = [self.storyboard instantiateViewControllerWithIdentifier:@"Email"];
    emailView.title = @"Email Signup";
    [self.navigationController pushViewController:emailView animated:YES];
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
}

@end
