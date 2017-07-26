//
//  SettingViewController.m
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/24.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "SettingViewController.h"
#import "NSLabel.h"
#import "CFConsts.h"
#import "CFNotifyHandleTool.h"
#import "NSLineView.h"

static NSInteger fontSize = 15;
static CGFloat contentLabelWidth = 150;
static CGFloat contentLabelHeight = 30;

static CGFloat margin = 10;

@interface SettingViewController ()<NSDatePickerCellDelegate>
//@property ( nonatomic, weak) NSLabel* startWorkLabel;
@property ( nonatomic, weak) NSDatePicker* startWorkDatePicker;
@property ( nonatomic, weak) NSDatePicker* lastWorkDatePicker;
@property ( nonatomic, weak) NSDatePicker* absentDatePicker;
@property ( nonatomic, weak) NSDatePicker* startAvDatePicker;
@property ( nonatomic, weak) NSDatePicker* lastAvDatePicker;
@property ( nonatomic, weak) NSPopUpButton* changeTimeButton;
@property ( nonatomic, weak) NSButton* overTimeButton;
@property ( nonatomic, weak) NSButton* autoLoginButton;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setupSubViews];
    
    [self setupData];
}

- (void)setupData {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    CFNotifyHandleTool* tool = [CFNotifyHandleTool sharedInstance];
    
    NSString* earliTakeCardTimeStr = [userDefaults objectForKey:EARLIEST_TAKEKARD_KEY] ?: earliestTakeCardTime;
    self.startWorkDatePicker.dateValue = [tool hourMinDateWithString:earliTakeCardTimeStr];
    
    NSString* latestTakeCardTimeStr = [userDefaults objectForKey:LATEST_TAKEKARD_KEY] ?: latestTakeCardTime;
    self.lastWorkDatePicker.dateValue = [tool hourMinDateWithString:latestTakeCardTimeStr];
    
    NSString* absentTimeStr = [userDefaults objectForKey:ABSENT_TIME_KEY] ?: absentTime;
    self.absentDatePicker.dateValue = [tool hourMinDateWithString:absentTimeStr];
    
    NSString* earliAvTimeStr = [userDefaults objectForKey:EARLIEST_AVAILABILITY_KEY] ?: earliestAvailabilityTime;
    self.startAvDatePicker.dateValue = [tool hourMinDateWithString:earliAvTimeStr];
    
    NSString* lastAvTimeStr = [userDefaults objectForKey:LATEST_AVAILABILITY_KEY] ?: latestAvailabilityTime;
    self.lastAvDatePicker.dateValue = [tool hourMinDateWithString:lastAvTimeStr];
    
    CGFloat workHourTime = [[userDefaults objectForKey:WORKHOUR_KEY] floatValue];
    workHourTime = workHourTime > 0 ? workHourTime : workHour;
    [self.changeTimeButton selectItemWithTitle:[NSString stringWithFormat:@"%.1f", workHourTime]];
    
    BOOL overTimeValue = [userDefaults boolForKey:OVERTIME_KEY];
    self.overTimeButton.state = overTimeValue;
    
    BOOL autoLoginValue = [userDefaults boolForKey:AUTOLOGIN_KEY];
    self.autoLoginButton.state = autoLoginValue;
}

- (void)setupSubViews {
    // 打卡时间
    NSLabel* startWorkLabel = [NSLabel textFieldWithString:@"最早打卡时间: "];
    [self.view addSubview:startWorkLabel];
//    self.startWorkLabel = startWorkLabel;
    startWorkLabel.alignment = NSTextAlignmentRight;
    [startWorkLabel sizeToFit];
    startWorkLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    startWorkLabel.textColor = [NSColor redColor];
    [startWorkLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin);
        make.top.equalTo(self.view).offset(margin*3);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSDatePicker* startWorkDatePicker = [[NSDatePicker alloc] init];
    self.startWorkDatePicker = startWorkDatePicker;
    startWorkDatePicker.datePickerStyle = NSTextFieldAndStepperDatePickerStyle;
    startWorkDatePicker.datePickerElements = NSHourMinuteDatePickerElementFlag;
    startWorkDatePicker.delegate = self;
    startWorkDatePicker.cell.tag = 1;
    [self.view addSubview:startWorkDatePicker];
    [startWorkDatePicker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startWorkLabel);
        make.left.equalTo(startWorkLabel.right).offset(margin * 3);
    }];


    NSLabel* lastWorkLabel = [NSLabel textFieldWithString:@"最晚打卡时间: "];
    [self.view addSubview:lastWorkLabel];
    //    self.startWorkLabel = startWorkLabel;
    lastWorkLabel.alignment = NSTextAlignmentRight;
    [lastWorkLabel sizeToFit];
    lastWorkLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    lastWorkLabel.textColor = [NSColor redColor];
    [lastWorkLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(startWorkLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSDatePicker* lastWorkDatePicker = [[NSDatePicker alloc] init];
    self.lastWorkDatePicker = lastWorkDatePicker;
    lastWorkDatePicker.datePickerStyle = NSTextFieldAndStepperDatePickerStyle;
    lastWorkDatePicker.datePickerElements = NSHourMinuteDatePickerElementFlag;
    lastWorkDatePicker.delegate = self;
    lastWorkDatePicker.cell.tag = 2;
    [self.view addSubview:lastWorkDatePicker];
    [lastWorkDatePicker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastWorkLabel);
        make.left.equalTo(lastWorkLabel.right).offset(margin * 3);
    }];
    
    // 缺席时间
    NSLabel* absentTimeLabel = [NSLabel textFieldWithString:@"缺席时间: "];
    [self.view addSubview:absentTimeLabel];
    //    self.startWorkLabel = startWorkLabel;
    absentTimeLabel.alignment = NSTextAlignmentRight;
    [absentTimeLabel sizeToFit];
    absentTimeLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    absentTimeLabel.textColor = [NSColor redColor];
    [absentTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(lastWorkLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSDatePicker* absentDatePicker = [[NSDatePicker alloc] init];
    self.absentDatePicker = absentDatePicker;
    absentDatePicker.datePickerStyle = NSTextFieldAndStepperDatePickerStyle;
    absentDatePicker.datePickerElements = NSHourMinuteDatePickerElementFlag;
    absentDatePicker.delegate = self;
    absentDatePicker.cell.tag = 3;
    [self.view addSubview:absentDatePicker];
    [absentDatePicker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(absentTimeLabel);
        make.left.equalTo(absentTimeLabel.right).offset(margin * 3);
    }];

    // 有效时间
    NSLabel* startAvTimeLabel = [NSLabel textFieldWithString:@"最早有效时间: "];
    [self.view addSubview:startAvTimeLabel];
    //    self.startWorkLabel = startWorkLabel;
    startAvTimeLabel.alignment = NSTextAlignmentRight;
    [startAvTimeLabel sizeToFit];
    startAvTimeLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    startAvTimeLabel.textColor = [NSColor redColor];
    [startAvTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(absentTimeLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSDatePicker* startAvDatePicker = [[NSDatePicker alloc] init];
    self.startAvDatePicker = startAvDatePicker;
    startAvDatePicker.datePickerStyle = NSTextFieldAndStepperDatePickerStyle;
    startAvDatePicker.datePickerElements = NSHourMinuteDatePickerElementFlag;
    startAvDatePicker.delegate = self;
    startAvDatePicker.cell.tag = 4;
    [self.view addSubview:startAvDatePicker];
    [startAvDatePicker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startAvTimeLabel);
        make.left.equalTo(startAvTimeLabel.right).offset(margin * 3);
    }];
    
    
    NSLabel* lastAvTimeLabel = [NSLabel textFieldWithString:@"最晚有效时间: "];
    [self.view addSubview:lastAvTimeLabel];
    //    self.startWorkLabel = startWorkLabel;
    lastAvTimeLabel.alignment = NSTextAlignmentRight;
    [lastAvTimeLabel sizeToFit];
    lastAvTimeLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    lastAvTimeLabel.textColor = [NSColor redColor];
    [lastAvTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(startAvTimeLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSDatePicker* lastAvDatePicker = [[NSDatePicker alloc] init];
    self.lastAvDatePicker = lastAvDatePicker;
    lastAvDatePicker.datePickerStyle = NSTextFieldAndStepperDatePickerStyle;
    lastAvDatePicker.datePickerElements = NSHourMinuteDatePickerElementFlag;
    lastAvDatePicker.delegate = self;
    lastAvDatePicker.cell.tag = 5;
    [self.view addSubview:lastAvDatePicker];
    [lastAvDatePicker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAvTimeLabel);
        make.left.equalTo(lastAvTimeLabel.right).offset(margin * 3);
    }];
    
    // 工作时长
    NSLabel* allWorkTimeLabel = [NSLabel textFieldWithString:@"工作时长: "];
    [self.view addSubview:allWorkTimeLabel];
    //    self.startWorkLabel = startWorkLabel;
    allWorkTimeLabel.alignment = NSTextAlignmentRight;
    [allWorkTimeLabel sizeToFit];
    allWorkTimeLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    allWorkTimeLabel.textColor = [NSColor redColor];
    [allWorkTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(lastAvTimeLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSPopUpButton* changeTimeButton = [[NSPopUpButton alloc] init];
    for (CGFloat i = 0.5; i <= 15; i+=0.5) {
        [changeTimeButton addItemWithTitle:[NSString stringWithFormat:@"%.1f", i]];
    }
    changeTimeButton.target = self;
    changeTimeButton.action = @selector(changeTimeButtonSelected:);
    self.changeTimeButton = changeTimeButton;
    [self.view addSubview:changeTimeButton];
    [changeTimeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allWorkTimeLabel);
        make.left.equalTo(allWorkTimeLabel.right).offset(margin * 3);
        make.size.equalTo(CGSizeMake(80, 20));
    }];
    
    // 周六、日提醒
    NSLabel* overTimeLabel = [NSLabel textFieldWithString:@"周六、日提醒: "];
    [self.view addSubview:overTimeLabel];
    //    self.startWorkLabel = startWorkLabel;
    overTimeLabel.alignment = NSTextAlignmentRight;
    [overTimeLabel sizeToFit];
    overTimeLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    overTimeLabel.textColor = [NSColor redColor];
    [overTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(allWorkTimeLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSButton* overTimeButton = [NSButton checkboxWithTitle:@"周六、日加班时使用" target:self action:@selector(overTimeButtonSelected:)];
    self.overTimeButton = overTimeButton;
    [self.view addSubview:overTimeButton];
    [overTimeButton sizeToFit];
    [overTimeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(overTimeLabel);
        make.left.equalTo(overTimeLabel.right).offset(margin * 3);
//        make.size.equalTo(CGSizeMake(100, 20));
        make.height.equalTo(20);
    }];
    
    // 开机自启动
    NSLabel* autoLoginLabel = [NSLabel textFieldWithString:@"随机自启动: "];
    [self.view addSubview:autoLoginLabel];
    //    self.startWorkLabel = startWorkLabel;
    autoLoginLabel.alignment = NSTextAlignmentRight;
    [autoLoginLabel sizeToFit];
    autoLoginLabel.font = [NSFont titleBarFontOfSize:fontSize];
//    autoLoginLabel.textColor = [NSColor redColor];
    [autoLoginLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkLabel);
        make.top.equalTo(overTimeLabel.bottom).offset(margin);
        make.width.equalTo(contentLabelWidth);
        make.height.equalTo(contentLabelHeight);
    }];
    
    NSButton* autoLoginButton = [NSButton checkboxWithTitle:@"建议开启" target:self action:@selector(autoLoginButtonSelected:)];
    self.autoLoginButton = autoLoginButton;
    [self.view addSubview:autoLoginButton];
    [autoLoginButton sizeToFit];
    [autoLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autoLoginLabel);
        make.left.equalTo(autoLoginLabel.right).offset(margin * 3);
        //        make.size.equalTo(CGSizeMake(100, 20));
        make.height.equalTo(20);
    }];
    
    // 退出应用
    NSButton* logoutButton = [NSButton buttonWithTitle:@"退出应用" target:self action:@selector(logOut:)];
    [self.view addSubview:logoutButton];
    [logoutButton sizeToFit];
    [logoutButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-2*margin);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(100, 20));
    }];
    
    NSLineView* bottomLineView = [[NSLineView alloc] init];
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(1);
        make.bottom.equalTo(logoutButton.top).offset(-2*margin);
    }];
    
    NSLabel* settingTipLabel = [NSLabel textFieldWithString:@"设置修改后立即生效。"];
    [self.view addSubview:settingTipLabel];
    //    self.startWorkLabel = startWorkLabel;
    settingTipLabel.alignment = NSTextAlignmentRight;
    [settingTipLabel sizeToFit];
    settingTipLabel.font = [NSFont systemFontOfSize:12];
    settingTipLabel.textColor = [NSColor grayColor];
    [settingTipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(bottomLineView.top).offset(-margin * 0.5);
    }];
}

- (void)datePickerCell:(NSDatePickerCell *)datePickerCell validateProposedDateValue:(NSDate * __nonnull *__nonnull)proposedDateValue timeInterval:(nullable NSTimeInterval *)proposedTimeInterval {
    NSString* objctValueKey = @"";
    switch (datePickerCell.tag) {
        case 1:
            objctValueKey = EARLIEST_TAKEKARD_KEY;
            break;
        case 2:
            objctValueKey = LATEST_TAKEKARD_KEY;
            break;
        case 3:
            objctValueKey = ABSENT_TIME_KEY;
            break;
        case 4:
            objctValueKey = EARLIEST_AVAILABILITY_KEY;
            break;
        case 5:
            objctValueKey = LATEST_AVAILABILITY_KEY;
            break;
            
        default:
            return;
    }
    
    NSString* dateStr = [[CFNotifyHandleTool sharedInstance] hourMinTimeStrWithDate:*proposedDateValue];
    [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:objctValueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"datepicker: %zd  date: %@", datePickerCell.tag, *proposedDateValue);
}

- (void)changeTimeButtonSelected:(NSPopUpButton *)button  {
    [[NSUserDefaults standardUserDefaults] setFloat:button.selectedItem.title.floatValue forKey:WORKHOUR_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)overTimeButtonSelected:(NSButton *)button  {
    [[NSUserDefaults standardUserDefaults] setBool:[button state] forKey:OVERTIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)autoLoginButtonSelected:(NSButton *)button  {
    [[CFNotifyHandleTool sharedInstance] setupAutologin:button.state];
}

- (void)logOut:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)dealloc {
    NSLog(@"dealloc----");
}
@end
