//
//  Donate.m
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/13/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import "Donate.h"

#define STRIPE_TEST_PUBLISHABLE_KEY @"pk_test_MiARA4enREaL2qjwRiFTQTH8"
#define STRIPE_LIVE_PUBLISHABLE_KEY @"pk_live_n1dkBdja3COHYjl9ANPpWRC8"

#define kNavTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kTabTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]

#define PAYPAL_TEST_CLIENT_ID @"ASB1mRAiUvWkyxPtKRFLVqb-t0gTm3gGCaXmDUoFjcphQWVUhGMI2x41kh18"
#define PAYPAL_LIVE_CLIENT_ID @"AY5WthBJdnQoR00DMY5M2I5QQ-kPqtZQIzCM1tYCleITjsz7g_Pe77kaiU7s"
#define kPayPalReceiverEmail @"mikeholp87@gmail.com"

@implementation Donate
@synthesize stripeBar, saveBtn, cancelBtn, moviePlayer, checkoutView, dimLayer, learnBtn;
@synthesize payButton, successView, environment, acceptCreditCards, completedPayment;

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
    
    self.navigationController.navigationBar.tintColor = kNavTintColor;
    [[UIToolbar appearance] setTintColor:kTabTintColor];
    self.navigationItem.rightBarButtonItem.tintColor = kNavTintColor;
    
    learnBtn.layer.masksToBounds = YES;
    learnBtn.layer.cornerRadius = 15.0f;
	
    self.acceptCreditCards = YES;
    self.environment = PayPalEnvironmentNoNetwork;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15.0f, 0, 14.0f);
    UIImage *payBackgroundImage = [[UIImage imageNamed:@"button_secondary.png"] resizableImageWithCapInsets:insets];
    UIImage *payBackgroundImageHighlighted = [[UIImage imageNamed:@"button_secondary_selected.png"] resizableImageWithCapInsets:insets];
    [self.payButton setBackgroundImage:payBackgroundImage forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:payBackgroundImageHighlighted forState:UIControlStateHighlighted];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    // Optimization: Prepare for display of the payment UI by getting network work done early
    [PayPalPaymentViewController setEnvironment:self.environment];
    [PayPalPaymentViewController prepareForPaymentUsingClientId:PAYPAL_TEST_CLIENT_ID];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSURL *url = [NSURL URLWithString:@"http://igg.me/p/388017/x/3027936"];
    //[[UIApplication sharedApplication] openURL:url];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView scalesPageToFit];
    [self.view addSubview:webView];
    [webView loadRequest:requestObj];
    
    /*
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://dwmcapp.com/Video/Project%20Video.mov"];
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
        moviePlayer.shouldAutoplay = YES;
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    */
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dude Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/****************************************************************************/
/*								Stripe Payment                              */
/****************************************************************************/

-(IBAction)useCreditCard:(id)sender
{
    self.navigationController.navigationBarHidden = YES;
    
    checkoutView = [[STPView alloc] initWithFrame:CGRectMake(15,50,290,55) andKey:STRIPE_TEST_PUBLISHABLE_KEY];
    checkoutView.delegate = self;
    
    dimLayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 700, 700)];
    dimLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    dimLayer.userInteractionEnabled = NO;
    [self.view addSubview:dimLayer];
    [self.view addSubview:checkoutView];
    
    stripeBar.hidden = NO;
    stripeBar.tintColor = kNavTintColor;
    [self.view addSubview:stripeBar];
}

-(IBAction)saveCard:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [checkoutView createToken:^(STPToken *token, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(error)
            [self hasError:error];
        else
            [self hasToken:token];
    }];
}

-(IBAction)cancelCard:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    
    [dimLayer removeFromSuperview];
    [checkoutView removeFromSuperview];
    [stripeBar removeFromSuperview];
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    saveBtn.enabled = valid;
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [message show];
}

- (void)hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://dwmcapp.com/API/stripe_api.php"]];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Payment Accepted!";
        hud.mode = MBProgressHUDModeText;
        
        if (error) {
            [self hasError:error];
        }else{
            NSLog(@"Success");
            [hud hide:YES afterDelay:1.0];
            [self cancelCard:self];
        }
    }];
}

/****************************************************************************/
/*								PayPal Payment                              */
/****************************************************************************/

- (IBAction)pay {
    
    // Remove our last completed payment, just for demo purposes.
    self.completedPayment = nil;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"30.00"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Bluetooth + Charger";
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Any customer identifier that you have will work here. Do NOT use a device- or
    // hardware-based identifier.
    NSString *customerId = @"user-11723";
    
    // Set the environment:
    // - For live charges, use PayPalEnvironmentProduction (default).
    // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
    // - For testing, use PayPalEnvironmentNoNetwork.
    [PayPalPaymentViewController setEnvironment:self.environment];
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:PAYPAL_TEST_CLIENT_ID receiverEmail:kPayPalReceiverEmail payerId:customerId payment:payment delegate:self];
    paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
    
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", self.completedPayment.confirmation);
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completed {
    NSLog(@"PayPal Payment Success!");
    self.completedPayment = completed;
    self.successView.hidden = NO;
    
    [self sendCompletedPaymentToServer:completed];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    NSLog(@"PayPal Payment Canceled");
    self.completedPayment = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************************************************************/
/*								Movie Player                                */
/****************************************************************************/

-(IBAction)learnMore:(id)sender
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:DEV_RLSE]];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        [request setPostValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"udid"];
    else{
        NSString *udid = nil;
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        if (uuid) {
            udid = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
            CFRelease(uuid);
        }
        [request setPostValue:udid forKey:@"udid"];
    }
    [request setPostValue:@"kickstarter" forKey:@"cmd"];
    [request setDelegate:self];
    [request setTag:0];
    [request startAsynchronous];
}

-(void)moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
        [player.view removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
