//
//  SettingWindowController.m
//  89-autoLogin
//
//  Created by 于传峰 on 2017/7/21.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "SettingWindowController.h"
#import "CFNotifyHandleTool.h"

@interface SettingWindowController ()<NSWindowDelegate>

@end

@implementation SettingWindowController

- (void)loadWindow {
    [super loadWindow];
//    self.window = [[NSWindow alloc] init];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file
}

- (void)windowWillClose:(NSNotification *)notification {
    [[CFNotifyHandleTool sharedInstance] handleNotification:nil];
    NSLog(@"windowWillClose--%@", notification);
}

@end
