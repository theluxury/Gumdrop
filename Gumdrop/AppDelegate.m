//
//  AppDelegate.m
//  Gumdrop
//
//  Created by Mark Wang on 1/22/15.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self setupMenuBar];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)setupMenuBar {
    // Create an NSStatusItem.
    float width = 19.0;
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:width];
    [_statusItem setImage:[NSImage imageNamed:@"menuBarIcon"]];
    [_statusItem setAlternateImage:[NSImage imageNamed:@"menuBarIconInactive"]];
    [_statusItem setMenu:_mainMenu];
    
    
}

@end
