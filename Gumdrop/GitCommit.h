//
//  GitCommit.h
//  Gumdrop
//
//  Created by Paul Musgrave on 2015-01-26.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitCommit : NSObject

@property (nonatomic, strong) NSString *githash;
@property (nonatomic, strong) NSString *githubURL;

@end
