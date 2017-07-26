//
//  CFConsts.h
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/21.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#ifndef CFConsts_h
#define CFConsts_h

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>


static NSString* HELPER_PROJ_ID = @"com.yuchuanfeng.notify-helper";

#if defined(DEBUG)||defined(_DEBUG)
static NSString* LAST_OPEN_TIME =  @"CF_LAST_OPEN_TIME";
#else
static NSString* LAST_OPEN_TIME =  @"CF_LAST_OPEN_TIME_RELEASE";
#endif

static NSString* FIRST_LOGIN_APP =  @"CF_FIRST_LOGIN_APP";

static NSString* NOTIFY_TITLE = @"下班提醒";
static NSString* NOTIFY_BUTTON_TITLE = @"继续工作";
static NSString* NOTIFY_CONTENT = @"虽然现在你可以回家了，但是为了公司更好的明天，建议你继续工作3小时！";

static NSString* WORKHOUR_KEY = @"CF_WORKHOUR_KEY";
static CGFloat const workHour = 9; // 工作时长

static NSString* EARLIEST_TAKEKARD_KEY = @"CF_EARLIEST_TAKEKARD_KEY";
static NSString* const earliestTakeCardTime = @"9:30"; // 最早打卡时间
static NSString* LATEST_TAKEKARD_KEY = @"CF_LATEST_TAKEKARD_KEY";
static NSString* const latestTakeCardTime = @"11:00"; // 最晚打卡时间

static NSString* ABSENT_TIME_KEY = @"CF_ABSENT_TIME_KEY";
static NSString* const absentTime = @"11:30"; // 缺席时间

static NSString* EARLIEST_AVAILABILITY_KEY = @"CF_EARLIEST_AVAILABILITY_KEY";
static NSString* const earliestAvailabilityTime = @"6:30"; // 最早有效时间（之前的不统计）
static NSString* LATEST_AVAILABILITY_KEY = @"CF_LATEST_AVAILABILITY_KEY";
static NSString* const latestAvailabilityTime = @"12:00"; // 最晚有效时间（之后的不统计）

static NSString* OVERTIME_KEY = @"CF_OVERTIME_KEY";
static BOOL const overTime = NO; // 周六、日 是否计算

static NSString* AUTOLOGIN_KEY = @"CF_AUTOLOGIN_KEY";
static BOOL const autologin = NO; // 自启动

#endif /* CFConsts_h */
