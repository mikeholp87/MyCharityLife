//
//  LoginUser.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/21/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "LoginUser.h"

@implementation LoginUser
@synthesize facebookBtn, twitterBtn, emailBtn, twitterInfo, facebookInfo, settings;

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
    
    settings = [[NSUserDefaults alloc] init];
    twitterInfo = [[NSMutableDictionary alloc] init];
    facebookInfo = [[NSMutableDictionary alloc] init];
    
    FBLoginView *loginview = [[FBLoginView alloc] init];
    loginview.frame = CGRectMake(30, 180, 80, 80);
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"facebook_login.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Log in to facebook";
            loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(50, 0, 271, 37);
        }
    }
    
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@",[NSString stringWithFormat:@"Welcome, %@", user.first_name]);
    [settings setObject:user forKey:@"fb_user"];
    [settings synchronize];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [settings setBool:FALSE forKey:@"login_email"];
    [settings setBool:TRUE forKey:@"login_facebook"];
    [settings setBool:FALSE forKey:@"login_twitter"];
    [settings synchronize];
    
    [self showFeed];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    /*
    self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    self.buttonPostPhoto.enabled = NO;
    self.buttonPickFriends.enabled = NO;
    self.buttonPickPlace.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
    
    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
    */
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (IBAction)loginTwitter:(id)sender
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        // Request access to the Twitter accounts
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                if (granted) {
                    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                    // Check if the users has setup at least one Twitter account
                    if (accounts.count > 0)
                    {
                        ACAccount *twitterAccount = [accounts objectAtIndex:0];
                        //NSLog(@"%@", twitterAccount);
                        
                        // Creating a request to get the info about a user on Twitter
                        // Pass exact username in parameter that we got at the time of login.
                        
                        SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                        [twitterInfoRequest setAccount:twitterAccount];
                        
                        // Making the request
                        
                        dispatch_queue_t downloadQueue = dispatch_queue_create("twitter", NULL);
                        
                        dispatch_async(downloadQueue, ^{
                            [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                if ([urlResponse statusCode] == 429) {
                                    return;
                                }
                                if (error) {
                                    return;
                                }
                                // Check if there is some response data
                                if (responseData) {
                                    NSError *error = nil;
                                    NSArray *TweetArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                    
                                    //NSLog(@"%@", TweetArray);
                                    
                                    int followers = [[(NSDictionary *)TweetArray objectForKey:@"followers_count"] integerValue];
                                    int following = [[(NSDictionary *)TweetArray objectForKey:@"friends_count"] integerValue];
                                    
                                    NSURL *url = [NSURL URLWithString:[[(NSDictionary *)TweetArray objectForKey:@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""]];
                                    NSData *data = [NSData dataWithContentsOfURL:url];
                                    UIImage *user_photo = [UIImage imageWithData:data];
                                    
                                    [self saveImage:user_photo withImageName:@"user_photo.png"];
                                    
                                    [twitterInfo setObject:[(NSDictionary *)TweetArray objectForKey:@"name"] forKey:@"name"];
                                    [twitterInfo setObject:[(NSDictionary *)TweetArray objectForKey:@"description"] forKey:@"description"];
                                    [twitterInfo setObject:[(NSDictionary *)TweetArray objectForKey:@"location"] forKey:@"user_location"];
                                    [twitterInfo setObject:[(NSDictionary *)TweetArray objectForKey:@"screen_name"] forKey:@"screen_name"];
                                    [twitterInfo setObject:[NSString stringWithFormat:@"%i", following] forKey:@"following"];
                                    [twitterInfo setObject:[NSString stringWithFormat:@"%i", followers] forKey:@"followers"];
                                    
                                    [settings setObject:twitterInfo forKey:@"twitter_info"];
                                    [settings synchronize];
                                    
                                    NSMutableDictionary *dict = [settings objectForKey:@"twitter_info"];
                                    //NSLog(@"++++ %@", dict);
                                }
                            }];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                [settings setBool:FALSE forKey:@"login_email"];
                                [settings setBool:FALSE forKey:@"login_facebook"];
                                [settings setBool:TRUE forKey:@"login_twitter"];
                                [settings synchronize];
                                
                                [self showFeed];
                            });
                        });
                    }
                } else {
                    NSLog(@"Access denied");
                }
            }];
        });
    }else{
        ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
        ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                // Remember that twitterType was instantiated above
                NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                
                // If there are no accounts, we need to pop up an alert
                if(twitterAccounts != nil && [twitterAccounts count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else {
                    ACAccount *account = [twitterAccounts objectAtIndex:0];
                    
                    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/account/verify_credentials.json"];
                    TWRequest *req = [[TWRequest alloc] initWithURL:url parameters:nil requestMethod:TWRequestMethodGET];
                    req.account = account;
                    
                    [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if(error != nil) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Error" message:@"There was an error talking to Twitter. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            return;
                        }
                        
                        // Parse the JSON response
                        NSError *jsonError = nil;
                        id resp = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                        
                        // If there was an error decoding the JSON, display a message to the user
                        if(jsonError != nil) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Error" message:@"Twitter is not acting properly right now. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            return;
                        }
                        
                        NSString *screenName = [resp objectForKey:@"screen_name"];
                        NSString *fullName = [resp objectForKey:@"name"];
                        NSString *location = [resp objectForKey:@"location"];
                        
                        NSLog(@"%@ %@ %@", screenName, fullName, location);
                        
                        // Make sure to perform our operation back on the main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Do something with the fetched data
                        });
                    }];
                }
            }
            NSLog(@"%@", error);
        }];
    }
}

- (IBAction)loginFacebook:(id)sender
{
    
    [settings setBool:FALSE forKey:@"login_email"];
    [settings setBool:TRUE forKey:@"login_facebook"];
    [settings setBool:FALSE forKey:@"login_twitter"];
    [settings synchronize];
}

- (IBAction)loginEmail:(id)sender
{
    [settings setBool:TRUE forKey:@"login_email"];
    [settings setBool:FALSE forKey:@"login_facebook"];
    [settings setBool:FALSE forKey:@"login_twitter"];
    [settings synchronize];
    
    UITabBarController *mainTab = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
    [self presentViewController:mainTab animated:YES completion:nil];
}

- (void)showFeed
{
    UITabBarController *mainTab = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
    [self presentViewController:mainTab animated:YES completion:nil];
}

- (void)saveImage:(UIImage*)image withImageName:(NSString*)imageName
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    
    [settings setObject:fullPath forKey:@"user_photo"];
    [settings synchronize];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    NSLog(@"image saved");
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
