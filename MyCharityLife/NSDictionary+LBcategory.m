//
//  NSDictionary+LBcategory.m
//
//  Created by Lucian Boboc on 4/8/13.
//

#import "NSDictionary+LBcategory.h"

@implementation NSDictionary (LBcategory)
- (id) JSONObjectForKey: (NSString *) key
{
    if([self respondsToSelector: @selector(objectForKey:)] == YES)
    {
        id object = [self objectForKey: key];
        if([object isKindOfClass:[NSNull class]])
        {
            NSLog(@"OBJECT IS NSNULL FOR KEY: %@",key);
            return nil;
        }
        return object;
    }
    else
    {
        NSLog(@"OBJECT IS NOT A DICTIONARY: %@",self);
        return nil;
    }
}

@end
