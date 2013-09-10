//
//  Profile.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/5/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "Profile.h"

#define kNavTintColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.000]

@implementation Profile
@synthesize settings, twitterInfo, profilePhoto, descView;
@synthesize profilePictureView, cityLbl, nameLbl;

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
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, 180, 22)];
    UIButton *logo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
    [logo setImage:[UIImage imageNamed:@"mcl_logo.png"] forState:UIControlStateNormal];
    [logo addTarget:self action:@selector(backToStart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    
    self.navigationController.navigationBar.tintColor = kNavTintColor;
    
    settings = [[NSUserDefaults alloc] init];
    
    if([settings boolForKey:@"login_twitter"]){
        twitterInfo = [settings objectForKey:@"twitter_info"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:@"/user_photo.png"];
        UIImage *user_photo = [UIImage imageWithContentsOfFile:path];
        
        [profilePhoto setImage:user_photo];
        
        [descView setText:[twitterInfo objectForKey:@"description"]];
    }else if([settings boolForKey:@"login_facebook"]){
        profilePictureView.hidden = NO;
        profilePictureView.profileID = [[settings objectForKey:@"fb_user"] objectForKey:@"username"];
        nameLbl.text = [[settings objectForKey:@"fb_user"] objectForKey:@"name"];
        cityLbl.text = [[[settings objectForKey:@"fb_user"] objectForKey:@"location"] objectForKey:@"name"];
        [descView setText:[[settings objectForKey:@"fb_user"] objectForKey:@"bio"]];
    }
}

- (void)showSettings
{
    UIViewController *profilesettings = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:profilesettings animated:YES];
}

@end
