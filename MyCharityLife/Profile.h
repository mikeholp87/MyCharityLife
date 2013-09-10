//
//  Profile.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/5/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Profile : UIViewController

@property(nonatomic,retain) NSUserDefaults *settings;
@property(nonatomic,retain) NSMutableDictionary *twitterInfo;

@property(nonatomic,retain) IBOutlet UIImageView *profilePhoto;
@property(nonatomic,retain) IBOutlet UITextView *descView;
@property(nonatomic,retain) IBOutlet UILabel *nameLbl;
@property(nonatomic,retain) IBOutlet UILabel *cityLbl;

@property (retain, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end
