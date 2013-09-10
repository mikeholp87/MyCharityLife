//
//  Donate.h
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/13/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ASIFormDataRequest.h"
#import "PayPalMobile.h"
#import "STPView.h"
#import "STPCard.h"
#import "MBProgressHUD.h"
#import "defs.h"

@interface Donate : UIViewController<UIWebViewDelegate, PayPalPaymentDelegate, STPViewDelegate>

@property(nonatomic,retain) IBOutlet UINavigationBar *stripeBar;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *saveBtn;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *cancelBtn;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *learnBtn;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;
@property(nonatomic, strong, readwrite) STPView *checkoutView;
@property(nonatomic, retain) UIImageView *dimLayer;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
