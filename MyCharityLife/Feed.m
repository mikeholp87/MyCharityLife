//
//  MyFeed.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/23/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "Feed.h"

#define kSelectedTabColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.000]

#define kNavTintColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.000]

@implementation Feed
@synthesize settings, facebookInfo, twitterInfo, feedTable, segControl, TwitterArray;
@synthesize FBFriendListTableView, FBFriendsArray;

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
    
    self.navigationController.navigationBar.tintColor = kNavTintColor;
	
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, 180, 22)];
    UIButton *logo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
    [logo setImage:[UIImage imageNamed:@"mcl_logo.png"] forState:UIControlStateNormal];
    [logo addTarget:self action:@selector(backToStart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
}

- (void)viewWillAppear:(BOOL)animated
{
    settings = [[NSUserDefaults alloc] init];
    FBFriendsArray = [[NSMutableArray alloc] init];
    
    if([settings boolForKey:@"login_facebook"]){
        facebookInfo = [settings objectForKey:@"facebook_info"];
        
        segControl.hidden = YES;
        
        [feedTable setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        UIBarButtonItem *invite = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(sendRequest)];
        [self.navigationItem setRightBarButtonItem:invite];
    }
    
    else if([settings boolForKey:@"login_twitter"]){
        twitterInfo = [settings objectForKey:@"twitter_info"];
        following = TRUE;
        [self fetchTwitter];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([settings boolForKey:@"login_twitter"])
        if(following)
            return NSLocalizedString(@"Following", @"Following");
        else
            return NSLocalizedString(@"Followers", @"Followers");
        else
            return NSLocalizedString(@"Friends", @"Friends");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [TwitterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSDictionary *userDict = [TwitterArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [userDict objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@",[userDict objectForKey:@"screen_name"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = kSelectedTabColor;
    else
        cell.backgroundColor = kNormalTabColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterUser *twitterUser = [self.storyboard instantiateViewControllerWithIdentifier:@"Twitter_User"];
    twitterUser.title = [[TwitterArray objectAtIndex:indexPath.row] objectForKey:@"screen_name"];
    [self.navigationController pushViewController:twitterUser animated:YES];
}

- (IBAction)selectView:(id)sender
{
    following = FALSE;
    followers = FALSE;
    switch ([segControl selectedSegmentIndex]) {
        case 0:
            following = TRUE;
            [self fetchTwitter];
            break;
        case 1:
            followers = TRUE;
            [self fetchTwitter];
            break;
        default:
            break;
    }
}

- (void)fetchTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                NSDictionary *params = @{@"cursor" : @"-1",
                                         @"screen_name" : twitterAccount.username,
                                         @"skip_status" : @"true",
                                         @"include_user_entities" : @"false"};
                
                SLRequest *twitterInfoRequest;
                
                if(following)
                    twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"] parameters:params];
                else
                    twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"] parameters:params];
                
                [twitterInfoRequest setAccount:twitterAccount];
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([urlResponse statusCode] == 429) return;
                        else if(error) return;
                        else if(responseData){
                            NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
                            SBJsonParser *js = [[SBJsonParser alloc] init];
                            TwitterArray = [[NSMutableArray alloc] initWithArray:[[js objectWithString:jsonString] objectForKey:@"users"]];
                            
                            [feedTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }
                    });
                }];
            }
        } else {
            NSLog(@"Access denied");
        }
    }];
}

- (void)sendRequest {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:@{
                        @"social_karma": @"5",
                        @"badge_of_awesomeness": @"1"}
                        options:0
                        error:&error];
    if (!jsonData) {
        NSLog(@"JSON error: %@", error);
        return;
    }
    
    NSString *giftStr = [[NSString alloc]
                         initWithData:jsonData
                         encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* params = [@{@"data" : giftStr} mutableCopy];
    
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Learn how to make your iOS apps social."
     title:nil
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)inviteFriends
{
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:^(FBViewController *sender, BOOL donePressed) {
        if (!donePressed) {
            return;
        }
        
        NSString *message;
        
        if (friendPickerController.selection.count == 0) {
            message = @"<No Friends Selected>";
        } else {
            
            NSMutableString *text = [[NSMutableString alloc] init];
            
            // we pick up the users from the selection, and create a string that we use to update the text view
            // at the bottom of the display; note that self.selection is a property inherited from our base class
            for (id<FBGraphUser> user in friendPickerController.selection) {
                if ([text length]) {
                    [text appendString:@", "];
                }
                [text appendString:user.name];
            }
            message = text;
        }
        
        [[[UIAlertView alloc] initWithTitle:@"You Picked:" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

@end
