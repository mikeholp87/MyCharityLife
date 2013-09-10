//
//  DwollaViewController.m
//  MyCharityLife
//
//  Created by Mike Holp on 8/16/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "DwollaViewController.h"

@implementation DwollaViewController
@synthesize dwollaAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dwollaAPI = [DwollaAPI sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(IBAction)getBalance
{
    float balance = [dwollaAPI getBalance];
    NSLog(@"%f", balance);
}

-(IBAction)getContacts
{
    NSArray* contacts = [dwollaAPI getContactsByName:@"" types:@"" limit:@""];
    NSLog(@"%@", [contacts description]);
}

-(IBAction)getFundingSources
{
    NSArray* sources = [dwollaAPI getFundingSources];
    DwollaFundingSource* person = [sources objectAtIndex:0];
    NSLog(@"%@", [person description]);
}

-(IBAction)getFirstSource
{
    NSArray* sources = [dwollaAPI getFundingSources];
    DwollaFundingSource* source = [sources objectAtIndex:0];
    NSLog(@"%@", [source description]);
}

-(IBAction)logout
{
    [dwollaAPI clearAccessToken];
}

-(IBAction)getTransactions
{
    NSArray *transactions = [dwollaAPI getTransactionsSince:@"04-08-12" withType:@"" withLimit:@"10" withSkip:@"0"];
    DwollaTransaction* transaction = [transactions objectAtIndex:0];
    NSLog(@"%@", [transaction description]);
}

-(IBAction)getTransaction;
{
    NSArray *transactions = [dwollaAPI getTransactionsSince:@"04-08-12" withType:@"" withLimit:@"10" withSkip:@"0"];
    DwollaTransaction* transaction = [transactions objectAtIndex:0];
    DwollaTransaction* trans = [dwollaAPI getTransaction:transaction.transactionID];
    NSLog(@"%@", [trans description]);
}

-(IBAction)getTransactionStats
{
    DwollaTransactionStats *stats = [dwollaAPI getTransactionStatsWithStart:@"" withEnd:@"" withTypes:@""];
    NSLog(@"%@", [stats description]);
}

-(IBAction)getAccountInfo
{
    DwollaUser* user = [dwollaAPI getAccountInfo];
    NSLog(@"%@", [user description]);
}

-(IBAction)getBasicInfo
{
    NSArray *transactions = [dwollaAPI getTransactionsSince:@"04-08-12" withType:@"" withLimit:@"10" withSkip:@"0"];
    DwollaTransaction* transaction = [transactions objectAtIndex:0];
    DwollaUser* user = [dwollaAPI getBasicInfoWithAccountID:transaction.destinationID];
    NSLog(@"%@", [user description]);
}

-(IBAction)sendMoney
{
    NSString* request = [dwollaAPI sendMoneyWithPIN:@"" destinationID:@"812-607-7497" destinationType:@"Dwolla" amount:@"0.01" facilitatorAmount:@"0" assumeCosts:@"false" notes:@"api_test" fundingSourceID:@""];
    NSLog(@"%@", request);
}

-(IBAction)requestMoney
{
    NSString* request = [dwollaAPI requestMoneyWithPIN:@"" sourceID:@"812-525-0238" sourceType:nil amount:@"0.01" facilitatorAmount:@"0.00" notes:nil];
    NSLog(@"%@", request);
}

-(IBAction)getNearby
{
    NSArray* contacts = [dwollaAPI getNearbyWithLatitude:@"41.6" Longitude:@"-93.6" Limit:@"5" Range:@"1"];
    NSLog(@"%@", [contacts description]);
}

// set OAuth Token as a key in NSUserDefaults (warning: this is not the safest way to go about storing credentials!):
+ (void)setToken:(NSString *)token {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:token forKey:@"token"];
    [settings synchronize];
}

// get previously saved OAuth Token.  Returns nil if not found.:
+ (NSString *)getToken {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"token"];
}

// returns user balance as string using previously saved OAuth token.  uses DwollaAPI library.  returns error message if failure
+ (NSString *)fetchBalance {
    DwollaAPI *client = [[DwollaAPI alloc] init];
    NSString *accesstoken = [self getToken];
    
    if (accesstoken != nil) {
        [client setAccessToken:accesstoken];
        
        // in case balance call fails, perhaps due to invalid token catch exception:
        @try {
            return [[NSString alloc] initWithFormat:@"$%.2f", [client getBalance]];
        }
        @catch (NSException *exception) {
            return @"Bad token?";
        }
        
    }
    
    else return @"No Token";
}

@end
