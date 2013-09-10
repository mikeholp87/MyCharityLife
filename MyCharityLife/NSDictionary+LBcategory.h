//
//  NSDictionary+LBcategory.h
//
//  Created by Lucian Boboc on 4/8/13.
//
// This category was created to help you with 2 things:
// 1. it checks if the JSON responds to objectForKey: method and returns nil if it doesn't, it also logs an error.
// 2. it checks if an object for a key is NSNull and if it is, it returns nil so you will never get back a NSNull object.

#import <Foundation/Foundation.h>

@interface NSDictionary (LBcategory)
- (id) JSONObjectForKey: (NSString *) key;
@end
