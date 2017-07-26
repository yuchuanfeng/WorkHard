//
//  NSLineView.m
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/21.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "NSLineView.h"

@implementation NSLineView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if (self = [super init]) {
        self.boxType = NSBoxCustom;
        self.borderType = NSNoBorder;
        self.fillColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

@end
