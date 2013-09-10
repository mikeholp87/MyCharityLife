//
//  LocationCell.m
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/12/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell
@synthesize locationLbl, noteLbl, dateLbl, photo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
