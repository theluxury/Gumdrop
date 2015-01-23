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

NSString * const APP_KEY = @"APP_KEY";
NSString * const AUTH_TOKEN = @"AUTH_TOKEN";

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

- (IBAction)connectToTrello:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // First, make sure there is an appKey
    if (![defaults objectForKey:APP_KEY]) {
        // Open a browser window that sends them to https://trello.com/1/appKey/generate, then open an alert that tells them to copy and paste the appkey.
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://trello.com/1/appKey/generate"]];
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Please allow Trello to generate a key and then copy and paste it into this prompt.";
        [alert addButtonWithTitle:@"Ok"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 400, 24)];
        [textField selectText:self];
        [alert setAccessoryView:textField];
        
        NSModalResponse response = [alert runModal];
        if(response == NSAlertFirstButtonReturn){
            [defaults setObject:[textField stringValue] forKey:APP_KEY];
        }
        
        return;
    }
    
    if (![defaults objectForKey:AUTH_TOKEN]) {
        // Open a browser window that sends them to https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=Gumdrop&expiration=1day&response_type=token&scope=read,write, then open an alert that tells them to copy and paste the appkey.
        NSString *authTokenUrl = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=Gumdrop&expiration=1day&response_type=token&scope=read,write", [defaults objectForKey:APP_KEY]];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:authTokenUrl]];
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Please allow Gumdrop to have access to read and write from your Trello boards. Please copy and paste the token into this prompt after you allow access.";
        [alert addButtonWithTitle:@"Ok"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 400, 24)];
        [textField selectText:self];
        [alert setAccessoryView:textField];
        
        NSModalResponse response = [alert runModal];
        if(response == NSAlertFirstButtonReturn)
            [defaults setObject:[textField stringValue] forKey:AUTH_TOKEN];
        return;
    }
    
    NSString *boardRequestString = [NSString stringWithFormat:@"https://api.trello.com/1/members/me/boards?key=%@&token=%@", [defaults objectForKey:APP_KEY], [defaults objectForKey:AUTH_TOKEN]];
    NSMutableURLRequest *boardRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:boardRequestString]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    boardRequest.HTTPMethod = @"GET";
    
    NSError *error;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:boardRequest returningResponse:nil error:&error];
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    if (error) {
        NSLog(@"error is %@", error);
        
    }
    NSLog(@"result is %@", result);
    
    NSLog(@"finished");

}
@end
