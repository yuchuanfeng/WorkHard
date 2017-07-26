//
//  AppDelegate.m
//  88-macOS通知
//
//  Created by 于传峰 on 2017/7/19.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "AppDelegate.h"
#import "CFNotifyHandleTool.h"
#import <objc/message.h>



@interface AppDelegate ()
@property ( nonatomic, strong) NSStatusItem* statusItem;

@property ( nonatomic, strong) NSPopover* popoverView;



@property ( nonatomic, weak) PopContentViewController* popoverVC;
@end

@implementation AppDelegate

    
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self checkIsLaunched];
    
    [self lisenNotification];
    
    [self  settingStatusItem];

    [self sleepMethod:nil];
    
    [[CFNotifyHandleTool sharedInstance] checkFirstLogin];
    
}
    
- (void)checkIsLaunched {
    BOOL startedAtLogin = NO;
    for (NSRunningApplication* app in [NSWorkspace sharedWorkspace].runningApplications) {
        if (app.bundleIdentifier == [[NSBundle mainBundle] bundleIdentifier]) {
            startedAtLogin = YES;
            break;
        }
    }
    
    if (startedAtLogin) {
        [NSApp terminate:self];
    }
}
    
- (void)settingStatusItem {
//    NSStatusItem *item = [NSStatusBar _statusItemWithLength:NSSquareStatusItemLength  withPriority:INT32_MAX];
//    if ( [[NSStatusBar systemStatusBar] respondsToSelector:@selector(_statusItemWithLength:withPriority:)]) {
//        _statusItem = ((NSStatusItem* (*)(id, SEL, const CGFloat, NSInteger))objc_msgSend)([NSStatusBar systemStatusBar], @selector(_statusItemWithLength:withPriority:), NSSquareStatusItemLength, INT64_MAX);
//    }else {
//    }

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    NSImage* image = [NSImage imageNamed:@"1"];
#if defined(DEBUG)||defined(_DEBUG)
    image = [NSImage imageNamed:@"2"];
#endif

    [_statusItem setImage:image];
    [_statusItem setToolTip:@"我想下班"];
    [_statusItem setHighlightMode:YES];
    _statusItem.target = self;
    _statusItem.action = @selector(showPoppoverView:);
    
    _popoverView = [[NSPopover alloc] init];
    _popoverView.behavior = NSPopoverBehaviorTransient;
    _popoverView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];

    PopContentViewController* popoverVC = [[PopContentViewController alloc] init];
    self.popoverVC = popoverVC;
    _popoverView.contentViewController = popoverVC;
    _popoverView.contentSize = CGSizeMake(330, 140);
    
    __weak typeof(self) weakSelf = self;
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent * _Nonnull event) {
        if (weakSelf.popoverView.isShown) {
            [weakSelf.popoverView close];
        }
    }];
}
    
- (void)showPoppoverView:(NSStatusBarButton *)button {
    [self.popoverView showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMinY];
}
    
- (void)lisenNotification { // NSWorkspaceScreensDidWakeNotification
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(sleepMethod:)
                                                            name:@"com.apple.screenIsUnlocked"
                                                          object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(sleepMethod:)
                                                               name:NSWorkspaceDidWakeNotification
                                                             object:nil];
//    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
//                                                           selector:@selector(sleepMethod:)
//                                                               name:NSWorkspaceScreensDidWakeNotification
//                                                             object:nil];
    
}
    
- (void)sleepMethod:(NSNotification *)noti {
    
    NSLog(@"waked: %@", noti);
    
    [[CFNotifyHandleTool sharedInstance] handleNotification:self.popoverVC];
}


@end
