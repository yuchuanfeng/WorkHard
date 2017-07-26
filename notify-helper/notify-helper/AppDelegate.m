//
//  AppDelegate.m
//  notify-helper
//
//  Created by 于传峰 on 2017/7/20.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    /*
     let mainAppIdentifier = "<main-app-bundle-id>"
     let running = NSWorkspace.shared().runningApplications
     var alreadyRunning = false
     
     // loop through running apps - check if the Main application is running
     for app in running {
     if app.bundleIdentifier == mainAppIdentifier {
     alreadyRunning = true
     break
     }
     }

     */
    NSString* mainAppIdentifier = @"yuchuanfeng.-8-Mac--";
    NSArray* runingApps = [NSWorkspace sharedWorkspace].runningApplications;
    BOOL alreadyRunning = NO;

    
    for (NSRunningApplication* app in runingApps) {
        if (app.bundleIdentifier == mainAppIdentifier) {
            alreadyRunning = YES;
            break;
        }
    }
    
    if (!alreadyRunning) {
        NSString *path = [[[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
        [[NSWorkspace sharedWorkspace] launchApplication:path];
        [NSApp terminate:nil];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
