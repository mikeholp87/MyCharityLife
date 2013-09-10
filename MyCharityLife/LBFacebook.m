//
//  LBFacebook.m
//  Bottle
//
//  Created by Lucian Boboc on 7/29/13.
//  Copyright (c) 2013 Lucian Boboc. All rights reserved.
//

#import "LBFacebook.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "NSDictionary+LBcategory.h"


#define kFacebookTokenInvalidatedError 190

#define kFacebookErrorMessage @"An account was not found, make sure you have a Facebook account setup in Settings."
#define kFacebookAccessNOTGranted @"Access to Facebook was not granted. Please go to the device Settings/Privacy/Facebook and allow access for this app"
#define kFacebookGetProfileError @"There was an error while receving your Facebook profile."

@interface LBFacebook ()
@property (strong,nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong,nonatomic) NSString *fbKey;
@property (copy, nonatomic) LBFacebookCompletionBlock completionBlock;
@end

@implementation LBFacebook
@synthesize accountStore = _accountStore;

- (id) initWithFacebookAPIKey: (NSString *) key completionBlock: (LBFacebookCompletionBlock) completionBlock
{
    if(!key)
    {
        NSLog(@"THE FACEBOOK KEY IS NIL!!!!!!!!!!!!");
        return nil;
    }
    
    self = [super init];
    if(self)
    {
        _accountStore = [[ACAccountStore alloc] init];
        _fbKey = key;
        self.completionBlock = completionBlock;
    }
    return self;
}

- (NSString *) configureErrorStringForCode: (NSInteger) code
{
    NSString *str = nil;
    switch (code) {
        case 2:
            str = @"The account require a missing property.";
            break;
        case 3:
            str = @"Authentication of its credential failed.";
            break;
        case 4:
            str = @"The account type is invalid.";
            break;
        case 5:
            str = @"An account already exists.";
            break;
        case 6:
            str = kFacebookErrorMessage;
            break;
        case 7:
            str = @"The application does not have permission to perform the operation.";
            break;
        case 8:
            str = @"The client's access info has incorrect or missing values.";
            break;
        default:
            break;
    }
    return str;
}



- (void) connectWithFacebookAction
{
    if(self.completionBlock)
        self.completionBlock(nil,LBFacebookButtonsActionDisable);
    
    [self getFacebookPermissions];
}



- (void) getFacebookPermissions
{
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    //        NSLog(@"accountStore: %@",self.accountStore);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSDictionary *facebookOptions = @{ACFacebookAppIdKey: self.fbKey, ACFacebookPermissionsKey: @[@"email"],ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        [self.accountStore requestAccessToAccountsWithType: facebookAccountType options: facebookOptions completion: ^(BOOL granted, NSError *error){
            if (granted)
            {
                self.facebookAccount = [[self.accountStore accountsWithAccountType: facebookAccountType] lastObject];
                NSLog(@"credential.token: %@",self.facebookAccount.credential.oauthToken);
                
                [self getUserDetailsFromFacebook];
            }
            else
            {
                if(error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"error: %@ code: %d",error.localizedDescription, error.code);
                        
                        NSString *errorString = error.localizedDescription;
                        if(error.code > 1 && error.code <= 8)
                            errorString = [self configureErrorStringForCode: error.code];
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: errorString delegate: nil cancelButtonTitle: @"OK" otherButtonTitles:nil];
                        [alert show];
                        
                        if(self.completionBlock)
                            self.completionBlock(nil,LBFacebookButtonsActionEnable);
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: kFacebookAccessNOTGranted delegate:nil cancelButtonTitle: @"OK" otherButtonTitles:nil];
                        [alert show];
                        
                        if(self.completionBlock)
                            self.completionBlock(nil,LBFacebookButtonsActionEnable);
                    });
                }
            }
        }];
    });
}



- (void) getUserDetailsFromFacebook
{
    SLRequest *reqeust = [SLRequest requestForServiceType: SLServiceTypeFacebook requestMethod: SLRequestMethodGET URL: [NSURL URLWithString: @"https://graph.facebook.com/me"] parameters: @{ @"fields" : @"email,id,name,first_name,last_name,username,picture"}];
    reqeust.account = self.facebookAccount;
    
    __block NSString *errorMsg = nil;
    [reqeust performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                errorMsg =  [NSString stringWithFormat: @"%@ %@", kFacebookGetProfileError,error.localizedDescription];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: errorMsg delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [alert show];
                
                if(self.completionBlock)
                    self.completionBlock(nil,LBFacebookButtonsActionEnable);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSError *jsonError = nil;
                NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &jsonError];
                if (jsonError)
                {
                    errorMsg =  [NSString stringWithFormat: @"%@ %@", kFacebookGetProfileError,error.localizedDescription];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: errorMsg delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [alert show];
                    
                    if(self.completionBlock)
                        self.completionBlock(nil,LBFacebookButtonsActionEnable);
                }
                else
                {
                    NSDictionary *errorDict = [responseJSON JSONObjectForKey: @"error"];
                    if(errorDict)
                    {
                        int errorCode = [[errorDict JSONObjectForKey: @"code"] intValue];
                        if(errorCode == kFacebookTokenInvalidatedError)
                        {
                            [self.accountStore renewCredentialsForAccount: self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                                if(renewResult == ACAccountCredentialRenewResultRenewed)
                                    [self getUserDetailsFromFacebook];
                                else
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: error.localizedDescription delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                                        [alert show];
                                        
                                        if(self.completionBlock)
                                            self.completionBlock(nil,LBFacebookButtonsActionEnable);
                                    });
                                }
                            }];
                        }
                        else
                        {
                            NSString *errorMsg = nil;
                            if([errorDict JSONObjectForKey: @"message"])
                                errorMsg  = [errorDict JSONObjectForKey: @"message"];
                            else
                                errorMsg = kFacebookGetProfileError;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: errorMsg delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                            [alert show];
                            
                            if(self.completionBlock)
                                self.completionBlock(nil,LBFacebookButtonsActionEnable);
                        }
                    }
                    else
                    {
                        NSString *token = self.facebookAccount.credential.oauthToken;
                        if(token)
                            responseJSON[@"token"] = token;
                        
                        NSDictionary *profileDictionary = [NSDictionary dictionaryWithDictionary: responseJSON];
                        
                        NSLog(@"FACEBOOK PROFILE: %@",profileDictionary);
                        
                        if(self.completionBlock)
                            self.completionBlock(profileDictionary,LBFacebookButtonsActionEnable);
                    }
                }
            });
        }
    }];
}



@end
