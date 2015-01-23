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
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *authToken;
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

- (IBAction)connectToTrello:(id)sender {
    // First, make sure there is an appKey
    if (!_appKey) {
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
            _appKey = [textField stringValue];
        }
        
        return;
    }
    
    if (!_authToken) {
        // Open a browser window that sends them to https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=Gumdrop&expiration=1day&response_type=token&scope=read,write, then open an alert that tells them to copy and paste the appkey.
        NSString *authTokenUrl = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=Gumdrop&expiration=1day&response_type=token&scope=read,write", _appKey];
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
            _authToken = [textField stringValue];
            
        return;
    }

    
    
    NSMutableURLRequest *tokenRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.trello.com/1/members/me/boards?key=949a9035e9bf9abac4af5d5e2c634d3b&token=f277f6639eeb612e148efd60dabae5b05a7d00ea896d4ed3169b4b297a6104f"]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    // Specify that it will be a POST request
    tokenRequest.HTTPMethod = @"GET";
    
    NSLog(@"starting get");
    
    // This is how we set header fields
    //[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
//    NSData *requestBodyData = [bodyData dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (!conn) {
//        NSLog(@"no connection to Trello :(");
//    }
//    
//    NSLog(@"got past conn");
    
    NSError *error;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:tokenRequest returningResponse:nil error:&error];
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    if (error)
        NSLog(@"error is %@", error);
    NSLog(@"result is %@", result);
    
    NSLog(@"finished");

}
@end
