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

- (IBAction)connectToTrello:(id)sender {
    // Create the request.
    // Auth token for read/write trello 1caa7763542bff79381d4328c09abb3b644f58944b0564365a4319f5fcc49951
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.trello.com/1/boards/JIA5o6lK?key=949a9035e9bf9abac4af5d5e2c634d3b&token=1caa7763542bff79381d4328c09abb3b644f58944b0564365a4319f5fcc49951&cards=open&lists=open"]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"GET";
    
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
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    if (error)
        NSLog(@"error is %@", error);
    NSLog(@"result is %@", result);
    
    NSLog(@"finished");

}
@end
