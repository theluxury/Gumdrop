//
//  AppDelegate.h
//  Gumdrop
//
//  Created by Mark Wang on 1/22/15.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (weak) IBOutlet NSMenu *mainMenu;

- (IBAction)connectToTrello:(id)sender;

@property (weak) IBOutlet NSMenu *boardListMenu;
@property (weak) IBOutlet NSMenu *columnListMenu;

@end

