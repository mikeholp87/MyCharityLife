//
//  MCLMain.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/18/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "MCLMain.h"

#define kNavTintColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.000]

@implementation MCLMain
@synthesize logInBtn, signUpBtn, locationManager, userCoordinate;

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
    
    [logInBtn useWhiteActionSheetStyle];
    [signUpBtn useWhiteActionSheetStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    userCoordinate = locationManager.location.coordinate;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

@end
