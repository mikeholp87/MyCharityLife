//
//  News.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/15/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "News.h"

#define kSelectedTabColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.000]

#define kNavTintColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.000]

@implementation News
@synthesize newsTable, tweets, accountStore, settings, twitterInfo;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    settings = [[NSUserDefaults alloc] init];
    
    if([settings boolForKey:@"login_twitter"]){
        accountStore = [[ACAccountStore alloc] init];
        tweets = [[NSMutableDictionary alloc] init];
        twitterInfo = [settings objectForKey:@"twitter_info"];
        
        [self fetchTimelineForUser:@"MyCharityLife1"];
    }
}

- (void)fetchTimelineForUser:(NSString *)username
{
    //  Step 0: Check that the user has local Twitter accounts
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    //  Step 2:  Create a request
                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                    
                    NSDictionary *params = @{@"screen_name" : username,
                                             @"include_rts" : @"0",
                                             @"trim_user" : @"1",
                                             @"count" : @"10"};
                    
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                    
                    //  Attach an account to the request
                    [request setAccount:[twitterAccounts lastObject]];
                    
                    //  Step 3:  Execute the request
                    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if(responseData) {
                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                NSError *jsonError;
                                NSArray *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                                
                                if (timelineData) {
                                    NSLog(@"Timeline Response: %@\n", timelineData);
                                    
                                    for(int i=0; i<[timelineData count]; i++){
                                        NSString *text = [[timelineData objectAtIndex:i] objectForKey:@"text"];
                                        
                                        NSString *url = [[[[[timelineData objectAtIndex:i] objectForKey:@"entities"] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"expanded_url"];
                                        
                                        [tweets setObject:text forKey:url];
                                    }
                                    
                                    NSLog(@"%@", tweets);
                                    
                                    //[newsTable performSelector:@selector(reloadData) withObject:nil afterDelay:2.0];
                                }else{
                                    // Our JSON deserialization went awry
                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                }
                            }else{
                                // The server did not respond successfully... were we rate-limited?
                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                            }
                        }
                    }];
                }else{
                    // Access was not granted, or an error occurred
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        });
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Latest Tweets", @"Latest Tweets");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tweets allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    cell.textLabel.text = [[tweets allValues] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[tweets allKeys] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = kSelectedTabColor;
    }else{
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = kNormalTabColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetail *webpage = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    webpage.tweetURL = [NSURL URLWithString:[[tweets allKeys] objectAtIndex:indexPath.row]];
    webpage.title = [[tweets allValues] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:webpage animated:YES];
}

@end
