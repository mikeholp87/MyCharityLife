//
//  Email.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/22/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface Email : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    bool newMedia;
    CGFloat animatedDistance;
}

@property(nonatomic,retain) NSUserDefaults *settings;
@property(nonatomic,retain) IBOutlet UITextField *firstNameField;
@property(nonatomic,retain) IBOutlet UITextField *lastNameField;
@property(nonatomic,retain) IBOutlet UITextField *emailField_twitter;
@property(nonatomic,retain) IBOutlet UITextField *emailField;
@property(nonatomic,retain) IBOutlet UITextField *passwdField;
@property(nonatomic,retain) IBOutlet UIView *twitterView;
@property(nonatomic,retain) IBOutlet UIView *emailView;
@property(nonatomic,retain) UIImage *picture;
@property(nonatomic,retain) UISegmentedControl *segControl;

@property(nonatomic,retain) NSMutableDictionary *emailInfo;
@property(nonatomic,retain) NSMutableDictionary *twitterInfo;

@end
