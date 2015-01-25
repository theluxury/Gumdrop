//
//  AppDelegate.m
//  Gumdrop
//
//  Created by Mark Wang on 1/22/15.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+Contains.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSArray *boardListArray;
@property (strong, nonatomic) NSDictionary *currSelectedBoard;
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
        
        NSString *appKeyString = [self getPromptText:@"Please allow Trello to generate a key and then copy and paste it into this prompt."];
        
        // this means they pressed "Okay" instead of "Cancel"
        if(appKeyString){
            [defaults setObject:appKeyString forKey:APP_KEY];
            if ([self checkForAuthToken])
                [self getDataFromTrello];
        }
        return;
    }
    
    if ([self checkForAuthToken])
        [self getDataFromTrello];
}

- (NSString *)getPromptText:(NSString *)prompt {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 400, 24)];
    [textField selectText:self];
    [alert setAccessoryView:textField];
    
    NSModalResponse response = [alert runModal];
    if (response == NSAlertFirstButtonReturn) {
        return [textField stringValue];
    }
    else
        return nil;
}

- (void) getDataFromTrello {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *boardRequestString = [NSString stringWithFormat:@"https://api.trello.com/1/members/me/boards?key=%@&token=%@", [defaults objectForKey:APP_KEY], [defaults objectForKey:AUTH_TOKEN]];
    NSMutableURLRequest *boardRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:boardRequestString]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    boardRequest.HTTPMethod = @"GET";
    
    NSError *error;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:boardRequest returningResponse:nil error:&error];
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    if (error) {
        NSLog(@"error is %@", error);
        if ([result contains:@"expired"]) {
            NSAlert *expiredAlert = [[NSAlert alloc] init];
            expiredAlert.messageText = @"Your authorization token seems to be expired. Please run Gumdrop again to get a new one.";
            [expiredAlert runModal];
            [defaults removeObjectForKey:AUTH_TOKEN];
        } else {
            NSAlert *expiredAlert = [[NSAlert alloc] init];
            expiredAlert.messageText = @"Something went wrong. Please run Gumdrop again to get the right application key and authorization token";
            [expiredAlert runModal];
            [defaults removeObjectForKey:APP_KEY];
            [defaults removeObjectForKey:AUTH_TOKEN];
        }
        return;
    }
    
    _boardListArray = [NSJSONSerialization JSONObjectWithData:returnData
                                                              options:0 error:nil];
    // NSLog(@"array is %@", userBoardArray);
    
    for (NSDictionary *dict in _boardListArray) {
        // Key equivalent must be empty string, not nil.
        NSMenuItem *boardListMenuItem = [[NSMenuItem alloc] initWithTitle:[dict objectForKey:@"name"] action:@selector(boardListMenuItemClicked:) keyEquivalent:@""];
        [_boardListMenu addItem:boardListMenuItem];
    }
}

- (void)boardListMenuItemClicked:(NSMenuItem *)menuItem {
    
    for (NSDictionary *dict in _boardListArray) {
        if ([[dict objectForKey:@"name"] isEqualToString:[menuItem title]]) {
            NSLog(@"clicked on %@", dict);
            _currSelectedBoard = dict;
        }
    }
    
}

- (BOOL)checkForAuthToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:AUTH_TOKEN]) {
        
        NSString *authTokenString = [self getNewAuthToken];
        if(authTokenString) {
            [defaults setObject:authTokenString forKey:AUTH_TOKEN];
            return YES;
        } else {
            // If they press cancel, I just assume they pasted in the wrong APP KEY, so get rid of it to restart chain
            [defaults removeObjectForKey:APP_KEY];
            return NO;
        }
    } else {
        return YES;
    }
}

- (NSString *) getNewAuthToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Open a browser window that sends them to https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=Gumdrop&expiration=1day&response_type=token&scope=read,write, then open an alert that tells them to copy and paste the appkey.
    NSString *authTokenUrl = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=Gumdrop&expiration=1day&response_type=token&scope=read,write", [defaults objectForKey:APP_KEY]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:authTokenUrl]];
    
    return [self getPromptText:@"Please allow Gumdrop to have access to read and write from your Trello boards, then copy and paste the token into this prompt after you allow access. If it did not take you to the right page, please press cancel and try again, making sure your app key is correct."];
}
@end
