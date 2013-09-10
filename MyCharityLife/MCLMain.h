//
//  MCLMain.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/18/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "GradientButton.h"

@interface MCLMain : UIViewController<CLLocationManagerDelegate>
@property(nonatomic,retain) IBOutlet GradientButton *signUpBtn;
@property(nonatomic,retain) IBOutlet GradientButton *logInBtn;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic) CLLocationCoordinate2D userCoordinate;

@end
