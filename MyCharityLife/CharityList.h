//
//  ViewController.h
//  MyCharityLife
//
//  Created by Michael Holp on 6/26/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "CharityDesc.h"
#import "CharityCell.h"

@interface CharityList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,retain) IBOutlet UITableView *charityTable;
@property(nonatomic,retain) NSMutableDictionary *charities;
@property(nonatomic,retain) NSMutableDictionary *charity_favorites;
@property(nonatomic,retain) NSMutableArray *charity_indexes;
@property(nonatomic,retain) NSMutableArray *charity_ids;
@property(nonatomic,retain) NSUserDefaults *settings;

@end
