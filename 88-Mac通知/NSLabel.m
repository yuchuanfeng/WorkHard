//
//  NSLabel.m
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/21.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "NSLabel.h"

@implementation NSLabel

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setBordered:NO];
        [self setEditable:NO];
        [self setSelectable:NO];
    }
    
    return self;
}


+ (instancetype)textFieldWithString:(NSString *)stringValue {
    NSLabel* label = [super textFieldWithString:stringValue];
    [label setBordered:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    label.drawsBackground = NO;
    label.bordered = NO;
    
    return label;
}

@end
