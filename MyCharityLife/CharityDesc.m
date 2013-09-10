//
//  CharityDesc.m
//  MyCharityLife
//
//  Created by Michael Holp on 6/26/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "CharityDesc.h"

@implementation CharityDesc
@synthesize charity_id, description, descView, titleView;

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
    
    [titleView setText:self.title];
    
    description = [[NSMutableDictionary alloc] init];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.demo.mycharitylife.com/MCL_App/mcl_api.php"]];
    [request setPostValue:charity_id forKey:@"charity_id"];
    [request setPostValue:@"fetch_charities" forKey:@"cmd"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    NSLog(@"Refresh Response String is: %@", jsonString);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    [description setDictionary:[parser objectWithString:jsonString error:NULL]];
    
    NSString *desc = [[description objectForKey:@"charity_desc"] objectForKey:@"charity_mission_statement"];
    if(![desc isKindOfClass:[NSNull class]])
        [descView setText:[[desc stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
}

- (IBAction)openWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[description objectForKey:@"charity_desc"] objectForKey:@"charity_website"]]];
}

- (IBAction)sendEmail:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[description objectForKey:@"charity_desc"] objectForKey:@"charity_email"]]];
}

- (IBAction)likeTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.twitter.com/%@",[[description objectForKey:@"charity_desc"] objectForKey:@"charity_twitter"]]]];
}

- (IBAction)likeFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[description objectForKey:@"charity_desc"] objectForKey:@"charity_facebook"]]];
}

- (IBAction)donateNow:(id)sender
{
    Donate *donate = [self.storyboard instantiateViewControllerWithIdentifier:@"Donate"];
    [self.navigationController pushViewController:donate animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fetch Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
