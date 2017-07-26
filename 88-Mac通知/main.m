//
//  main.m
//  88-macOS通知
//
//  Created by 于传峰 on 2017/7/19.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication* app = [NSApplication sharedApplication];
    id delegate = [[AppDelegate alloc] init];
    app.delegate = delegate;
    return NSApplicationMain(argc, argv);
}
