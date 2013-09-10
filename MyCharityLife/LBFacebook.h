//
//  LBFacebook.h
//  Bottle
//
//  Created by Lucian Boboc on 7/29/13.
//  Copyright (c) 2013 Lucian Boboc. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error LBFacebook is ARC only.
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#error LBFacebook needs iOS 6.0 or later.
#endif



#import <Foundation/Foundation.h>

#define kFacebookKey @"434676999905114"

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