//
//  PopContentViewController.h
//  88-macOS通知
//
//  Created by 于传峰 on 2017/7/19.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, PopTipType) {
    PopTipTypeNormal = 0, // 正常
    PopTipTypeTooLate, // 太晚了
    PopTipTypeEarly, // 太早了
    PopTipTypeNotWrok, // 休息时间
    PopTipTypeAbsend, // 迟到
    PopTipTypeInvalid // 无效
};

@interface PopContentViewController : NSViewController
@property( nonatomic, copy) NSString* timeStr;
@property( nonatomic, copy) NSString* endTimeStr;
@property( nonatomic, assign) PopTipType tipType;
@end
