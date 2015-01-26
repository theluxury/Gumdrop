//
//  GitManager.h
//  Gumdrop
//
//  Created by Paul Musgrave on 2015-01-26.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitCommit.h"

@interface GitManager : NSObject

@property (nonatomic, strong) NSString *repoPath;

- (instancetype)initWithPath:(NSString *)path
- (GitCommit *)getHeadCommit;

@end
