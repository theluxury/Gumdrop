//
//  GitManager.m
//  Gumdrop
//
//  Created by Paul Musgrave on 2015-01-26.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import "GitManager.h"

@implementation GitManager

- (instancetype)initWithPath:(NSString *)path
{
    if(self = [super init]){
        _repoPath = path;
    }
    return self;
}

- (GitCommit *)getHeadCommit
{
    
}



@end
