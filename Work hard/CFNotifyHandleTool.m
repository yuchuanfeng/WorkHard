//
//  CFNotifyHandleTool.m
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/20.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "CFNotifyHandleTool.h"
#import "NSString+extension.h"
#import "CFConsts.h"




static CFNotifyHandleTool* _sharedInstance;


@interface CFNotifyHandleTool()

@property ( nonatomic, weak) PopContentViewController* popVC;

// setting
@property( nonatomic, copy) NSString* earliestTakeCardTime;
@property( nonatomic, copy) NSString* latestTakeCardTime;
@property( nonatomic, copy) NSString* absentTime;
@property( nonatomic, copy) NSString* earliestAvailabilityTime;
@property( nonatomic, copy) NSString* latestAvailabilityTime;

@property( nonatomic, assign) CGFloat workHour;

@property( nonatomic, assign) BOOL overTime;


// dateFormatter
@property ( nonatomic, strong) NSDateFormatter* dateFormatter;

@property ( nonatomic, strong) NSDateFormatter* hourFormatter;

@property ( nonatomic, strong) NSDateFormatter* dayFormatter;

@property ( nonatomic, strong) NSDateFormatter* hourMinFormatter;
@end


@implementation CFNotifyHandleTool

- (void)getSettingData {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.earliestTakeCardTime = [userDefaults objectForKey:EARLIEST_TAKEKARD_KEY] ?: earliestTakeCardTime;
    
    self.latestTakeCardTime = [userDefaults objectForKey:LATEST_TAKEKARD_KEY] ?: latestTakeCardTime;
    
    self.absentTime = [userDefaults objectForKey:ABSENT_TIME_KEY] ?: absentTime;
    
    self.earliestAvailabilityTime = [userDefaults objectForKey:EARLIEST_AVAILABILITY_KEY] ?: earliestAvailabilityTime;
    
    self.latestAvailabilityTime = [userDefaults objectForKey:LATEST_AVAILABILITY_KEY] ?: latestAvailabilityTime;
    
    CGFloat workHourTime = [[userDefaults objectForKey:WORKHOUR_KEY] floatValue];
    self.workHour = workHourTime > 0 ? workHourTime : workHour;
    
    self.overTime = [userDefaults boolForKey:OVERTIME_KEY];
}

- (void)handleNotification:(PopContentViewController *)popVC {
    
    if (!popVC) {
        popVC = self.popVC;
    }
    if (!popVC) {
        NSAssert(popVC != nil, @"有问题。。。");
        return;
    }
    self.popVC = popVC;
    
    [self getSettingData];
    
    NSDate* currentDate = [NSDate date];
    NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger currentWeekDay;
//    [calendar getHour:&currentHour minute:&currentMin second:&currentSecond nanosecond:NULL fromDate:currentDate];
    [calendar getEra:NULL yearForWeekOfYear:NULL weekOfYear:NULL weekday:&currentWeekDay fromDate:currentDate];
    
    if (!self.overTime && (currentWeekDay == 1 || currentWeekDay == 7)) {
        popVC.tipType = PopTipTypeNotWrok;
        return;
    }
    NSTimeInterval earliestAvailabilityTimeInterval = [[self.hourFormatter dateFromString:[self.earliestAvailabilityTime appendingCurrentDate:self.dayFormatter]] timeIntervalSince1970];
    NSTimeInterval latestAvailabilityTimeInterval = [[self.hourFormatter dateFromString:[self.latestAvailabilityTime appendingCurrentDate:self.dayFormatter]] timeIntervalSince1970];
    
    NSTimeInterval lastTime = [[NSUserDefaults standardUserDefaults] doubleForKey:LAST_OPEN_TIME];
    NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
    BOOL insideNormalTime = lastTime > earliestAvailabilityTimeInterval && lastTime < latestAvailabilityTimeInterval;
    if (lastTime > 0 && [calendar isDateInToday:lastDate] && insideNormalTime) {
        [self setNotificationWithStartDate:lastDate popVC:popVC];
        return;
    }
    
    
    if (currentTimeInterval < earliestAvailabilityTimeInterval) {
        popVC.tipType = PopTipTypeInvalid;
        return;
    }
    
    if (currentTimeInterval > latestAvailabilityTimeInterval) {
        popVC.tipType = PopTipTypeInvalid;
        return;
    }
    
    
    [self setNotificationWithStartDate:currentDate popVC:popVC];
    
    [[NSUserDefaults standardUserDefaults] setDouble:currentTimeInterval forKey:LAST_OPEN_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNotificationWithStartDate:(NSDate *)startDate popVC:(PopContentViewController *)popVC{
    NSTimeInterval currentTimeInterval = [startDate timeIntervalSince1970];
    
    NSTimeInterval earliestTakeCardTimeInterval = [[self.hourFormatter dateFromString:[self.earliestTakeCardTime appendingCurrentDate:self.dayFormatter]] timeIntervalSince1970];
    NSTimeInterval absentTimeInterval = [[self.hourFormatter dateFromString:[self.absentTime appendingCurrentDate:self.dayFormatter]] timeIntervalSince1970];
    NSTimeInterval latestTakeCardTimeInterval = [[self.hourFormatter dateFromString:[self.latestTakeCardTime appendingCurrentDate:self.dayFormatter]] timeIntervalSince1970];
    
    NSTimeInterval savedTimeInterval = currentTimeInterval;
    if (savedTimeInterval < earliestTakeCardTimeInterval) {
        savedTimeInterval = earliestTakeCardTimeInterval;
    }else if (savedTimeInterval > absentTimeInterval){
        savedTimeInterval = latestTakeCardTimeInterval;
    }
//#if defined(DEBUG)||defined(_DEBUG)
//    NSTimeInterval workTime = 5;
//#else
    NSTimeInterval workTime = self.workHour * 60 * 60;
//#endif
    NSTimeInterval workEndTime = savedTimeInterval + workTime;
    popVC.tipType = PopTipTypeNormal;
    if (currentTimeInterval < earliestTakeCardTimeInterval) { // 来早了
        popVC.tipType = PopTipTypeEarly;
    }else if (currentTimeInterval > absentTimeInterval){ // 缺席了
        popVC.tipType = PopTipTypeTooLate;
    }else if (currentTimeInterval > latestTakeCardTimeInterval) { // 迟到了
        popVC.tipType = PopTipTypeAbsend;
    }

    
    NSDate* workEndDate = [NSDate dateWithTimeIntervalSince1970:workEndTime];
    
    popVC.timeStr = [self.dateFormatter stringFromDate:startDate];
    NSString* endTimeStr = [self.dateFormatter stringFromDate:workEndDate];
    popVC.endTimeStr = endTimeStr;
    
    if ([[NSDate date] timeIntervalSince1970] - currentTimeInterval > 3) {
        return;
    }
    
    for (NSUserNotification* noti in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:noti];
    }
    
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = NOTIFY_TITLE;
    localNotify.informativeText = NOTIFY_CONTENT;
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    localNotify.deliveryDate = workEndDate;
    localNotify.hasActionButton = NO;
    localNotify.otherButtonTitle = NOTIFY_BUTTON_TITLE;
    [[NSUserNotificationCenter defaultUserNotificationCenter]  scheduleNotification:localNotify];
}

#pragma mark - date
- (NSDate *)hourMinDateWithString:(NSString *)timeStr {
    return [self.hourMinFormatter dateFromString:timeStr];
}

- (NSString *)hourMinTimeStrWithDate:(NSDate *)date {
    return [self.hourMinFormatter stringFromDate:date];
}


- (void)checkFirstLogin {
    BOOL first = ![[NSUserDefaults standardUserDefaults] boolForKey:FIRST_LOGIN_APP];
    if (first) {
        [self setupAutologin:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_LOGIN_APP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setupAutologin:(BOOL)autoLogin {
    [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:AUTOLOGIN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!SMLoginItemSetEnabled((__bridge CFStringRef)HELPER_PROJ_ID, (BOOL)autoLogin)) {
        NSLog(@"The login was not successful");
    }
}

#pragma mark - other
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        //        _dateFormatter.dateFormat = @"HH:mm:ss";
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }
    
    return _dateFormatter;
}

- (NSDateFormatter *)hourFormatter {
    if (!_hourFormatter) {
        _hourFormatter = [[NSDateFormatter alloc] init];
        _hourFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        _hourFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }
    
    return _hourFormatter;
}

- (NSDateFormatter *)dayFormatter {
    if (!_dayFormatter) {
        _dayFormatter = [[NSDateFormatter alloc] init];
        _dayFormatter.dateFormat = @"yyyy-MM-dd";
        _dayFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }
    
    return _dayFormatter;
}

- (NSDateFormatter *)hourMinFormatter {
    if (!_hourMinFormatter) {
        _hourMinFormatter = [[NSDateFormatter alloc] init];
        _hourMinFormatter.dateFormat = @"HH:mm";
        _hourMinFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }
    return _hourMinFormatter;
}


+ (void)initialize
{
    [CFNotifyHandleTool sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}



- (id)copyWithZone:(NSZone *)zone
{
    return [CFNotifyHandleTool sharedInstance];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [CFNotifyHandleTool sharedInstance];
}




@end
