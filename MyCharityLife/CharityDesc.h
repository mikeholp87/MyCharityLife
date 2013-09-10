//
//  CharityDesc.h
//  MyCharityLife
//
//  Created by Michael Holp on 6/26/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "Donate.h"

@interface CharityDesc : UIViewController
@property(nonatomic,retain) NSString *charity_id;
@property(nonatomic,retain) NSMutableDictionary *description;
@property(nonatomic,retain) IBOutlet UITextView *descView;
@property(nonatomic,retain) IBOutlet UITextView *titleView;

@end
