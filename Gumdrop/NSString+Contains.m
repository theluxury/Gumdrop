//
//  NSString+Contains.m
//  Gumdrop
//
//  Created by Mark Wang on 1/23/15.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)contains:(NSString *)string {
    if ([self rangeOfString:string options:NSCaseInsensitiveSearch].location == NSNotFound)
        return NO;
    
    return YES;
}

@end
