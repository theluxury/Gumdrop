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
        
        // initialize info about the repo
        // ## this is pretty hacky, but for now just assume the origin is github
        NSString *remoteInfo = [self runCommand:@"git remote -v"];
        // Probably a better way to parse this somehow?
        // we want to extract 'PeppermintInc/Gumdrop' from 'origin	git@github.com:PeppermintInc/Gumdrop.git (fetch)'
        NSString *firstLine = [remoteInfo componentsSeparatedByString:@"\n"][0];
        NSString *remoteURL = [firstLine componentsSeparatedByString:@" "][2]; // (note that we want 2, not 1, due to double space)
        NSString *gpath = [remoteURL componentsSeparatedByString:@":"][1];
        NSString *name = [gpath substringToIndex:gpath.length-4];
        self.githubName = name;
    }
    return self;
}


- (GitCommit *)getHeadCommit
{
    GitCommit *commit = [[GitCommit alloc] init];
    NSString *commitHash = [self runCommand:@"git rev-parse HEAD"];
    commit.githash = commitHash;
    commit.githubURL = [NSString stringWithFormat:@"https://github.com/%@/commit/%@", self.githubName, commitHash];
    return commit;
}


// lazy way; http://stackoverflow.com/questions/412562/execute-a-terminal-command-from-a-cocoa-app
- (NSString *)runCommand:(NSString *)commandToRun
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    [task setCurrentDirectoryPath:self.repoPath];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    NSLog(@"run command: %@",commandToRun);
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *output;
    output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}


@end
