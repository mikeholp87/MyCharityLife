//
//  LBFacebook.h
//  Bottle
//
//  Created by Lucian Boboc on 7/29/13.
//  Copyright (c) 2013 Lucian Boboc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFacebookKey @"1396364633913432"

typedef NS_ENUM(NSUInteger, LBFacebookButtonsAction){
    LBFacebookButtonsActionEnable,
    LBFacebookButtonsActionDisable,
};

// LBFacebookButtonsAction is used to enable/disable facebook signin/sign up buttons till the profile dictionary is receive
typedef void(^LBFacebookCompletionBlock)(NSDictionary *facebookDictionary, LBFacebookButtonsAction actionType);

@interface LBFacebook : NSObject
- (id) initWithFacebookAPIKey: (NSString *) key completionBlock: (LBFacebookCompletionBlock) completionBlock;
- (void) connectWithFacebookAction;
@end
