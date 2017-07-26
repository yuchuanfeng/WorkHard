//
//  CFNotifyHandleTool.h
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/20.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "PopContentViewController.h"

@interface CFNotifyHandleTool : NSObject
+ (instancetype)sharedInstance;

- (void)handleNotification:(PopContentViewController *)popVC;

- (void)setNotificationWithStartDate:(NSDate *)startDate popVC:(PopContentViewController *)popVC;

// dateFormatter
- (NSDate *)hourMinDateWithString:(NSString *)timeStr;

- (NSString *)hourMinTimeStrWithDate:(NSDate *)date;

// login
- (void)checkFirstLogin;
- (void)setupAutologin:(BOOL)autoLogin;
@end
