//
//  Watchlist.h
//  MyCharityLife
//
//  Created by Michael Holp on 7/18/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "CharityCell.h"

typedef void (^ForwardGeoCompletionBlock)(CLLocationCoordinate2D coords);
typedef void (^ReverseGeoCompletionBlock)(NSString *zipcode);

@interface Watchlist : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>
@property(nonatomic,retain) UISearchDisplayController *searchDisplayController;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UITableView *watchlistTable;
@property(nonatomic,retain) NSMutableDictionary *charities;
@property(nonatomic,retain) NSMutableArray *searchResults;

@property(nonatomic,retain) NSMutableDictionary *charity_favorites;
@property(nonatomic,retain) NSMutableArray *charity_indexes;
@property(nonatomic,retain) NSMutableArray *charity_ids;
@property(nonatomic,retain) NSUserDefaults *settings;

@property(nonatomic,retain) CLGeocoder *geocoder;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic) CLLocationCoordinate2D userCoordinate;

@end
