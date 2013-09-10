//
//  Settings.h
//  MyCharityLife
//
//  Created by Michael Holp on 6/29/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AppDelegate.h"

@interface Settings : UITableViewController<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
{
    bool newMedia;
    CGFloat animatedDistance;
}

@property(nonatomic,retain) NSUserDefaults *settings;
@property(nonatomic,retain) NSMutableDictionary *twitterInfo;
@property(nonatomic,retain) NSMutableDictionary *facebookInfo;
@property(nonatomic,retain) NSMutableDictionary *emailInfo;
@property(nonatomic,retain) UIImage *picture;

@property(nonatomic,retain) UITextField *nameField;
@property(nonatomic,retain) UITextField *passwdField;
@property(nonatomic,retain) UITextField *emailField;
@property(nonatomic,retain) UISegmentedControl *segControl;

@end
