//
//  NSString+extension.m
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/20.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

- (NSString *)appendingCurrentDate:(NSDateFormatter *)formatter {
    return [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:[NSDate date]], self];
}

@end
