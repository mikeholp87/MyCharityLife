//
//  Donate.m
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/13/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import "Donate.h"

@implementation Donate
@synthesize dwollaAPI, settings, amounts, amountsTable, buttonPostStatus, loggedInUser;

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
    
    self.title = @"Fundraising";
    self.navigationController.navigationBarHidden = NO;
    
    settings = [[NSUserDefaults alloc] init];
    
    //amounts = [NSArray arrayWithObjects:@"1", @"5", @"20", @"50", @"100", "200", "500", "999", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dude Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

/****************************************************************************/
/*								Donate Table                                */
/****************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [amounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    cell.textLabel.text = [amounts objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/****************************************************************************/
/*								Dwolla Payment                              */
/****************************************************************************/

-(IBAction)login
{
    NSArray *scopes = [[NSArray alloc] initWithObjects:@"send", nil];
    DwollaOAuth2Client *client = [[DwollaOAuth2Client alloc] initWithFrame:CGRectMake(0, 0, 320, 460) key:@"X5UnREHP3e33H3zYYbDdKg0EgIh2F53xNzQkbBbc3zy0PqVd5Q" secret:@"/6wE5M8azH1tMRiHb6TGBlSKcpv6DX8tReOBjMu9c0WgvJ8FuR" redirect:@"https://www.dwolla.com" response:@"code" scopes:scopes view:self.view reciever:self];
    [client login];
}

-(void)successfulLogin
{
    DwollaViewController* actions = [[DwollaViewController alloc] init];
    //[actions setModalTransitionStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:actions animated:YES];
}

-(void)failedLogin:(NSArray*)errors
{
    
}

/****************************************************************************/
/*								Social Networks                             */
/****************************************************************************/

- (IBAction)sendTweet:(id)sender
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled)
                    NSLog(@"Cancelled");
                else{
                    NSLog(@"Done");
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler = myBlock;
            
            NSURL *url = [NSURL URLWithString:@"www.dwmcapp.com"];
            [controller setInitialText:[NSString stringWithFormat:@"Never lose your car again! Download \"Dude Where's My Car?\" for FREE @ %@ @GroovyCar", url]];
            [self presentViewController:controller animated:YES completion:nil];
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }else{
        [self showTweetSheet];
    }
}

- (IBAction)postStatus:(id)sender
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled)
                    NSLog(@"Cancelled");
                else{
                    NSLog(@"Done");
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler = myBlock;
            
            [controller setInitialText:@"Never lose your car again! Download \"Dude Where's My Car?\" for FREE!"];
            [controller addURL:[NSURL URLWithString:@"www.dwmcapp.com"]];
            [controller addImage:[UIImage imageNamed:@"AppIcon.png"]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't post right now, make sure your device has an internet connection and you have at least one Facebook account setup." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }else{
        
    }
}

// Post Status Update button handler; will attempt different approaches depending upon configuration.
- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare name:@"Hello Facebook" caption:nil description:@"The 'Hello Facebook' sample application showcases simple Facebook integration." picture:nil clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        } else {
            NSLog(@"Success!");
        }
    }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:nil image:nil url:urlToShare handler:nil];
        
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", [[settings objectForKey:@"fb_user"] objectForKey:@"username"], [NSDate date]];
                
                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                
                //connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession| FBRequestConnectionErrorBehaviorAlertUser|FBRequestConnectionErrorBehaviorRetry;
                
                [connection addRequest:[FBRequest requestForPostStatusUpdate:message] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    [self showAlert:message result:result error:error];
                    self.buttonPostStatus.enabled = YES;
                }];
                [connection start];
                
                self.buttonPostStatus.enabled = NO;
            }];
        }
    }
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            if (!error) {
                action();
            } else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
                [[[UIAlertView alloc] initWithTitle:@"Permission denied" message:@"Unable to get permission to post" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    } else {
        action();
    }
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error {
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)showTweetSheet
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                NSLog(@"Tweet Sheet has been dismissed.");
            }];
        });
    };
    
    [tweetSheet setInitialText:@"just setting up my twttr"];
    
    if (![tweetSheet addImage:[UIImage imageNamed:@"larry.png"]]) {
        NSLog(@"Unable to add the image!");
    }
    
    if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}

@end
