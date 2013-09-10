//
//  NewsDetail.h
//  MyCharityLife
//
//  Created by Mike Holp on 8/4/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetail : UIViewController<UIWebViewDelegate>

@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property(nonatomic,retain) NSURL *tweetURL;

@end
