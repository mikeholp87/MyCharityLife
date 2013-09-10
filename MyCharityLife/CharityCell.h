//
//  LocationCell.h
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/12/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *locationLbl;
@property (nonatomic, retain) IBOutlet UILabel *noteLbl;
@property (nonatomic, retain) IBOutlet UILabel *dateLbl;
@property (nonatomic, retain) IBOutlet UIButton *photo;

@end
