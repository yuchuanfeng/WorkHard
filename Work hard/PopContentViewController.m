//
//  PopContentViewController.m
//  88-macOS通知
//
//  Created by 于传峰 on 2017/7/19.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "PopContentViewController.h"
#import "CFConsts.h"
#import "CFNotifyHandleTool.h"
#import "NSLabel.h"
#import "NSLineView.h"
#import "SettingWindowController.h"
#import "SettingViewController.h"


static CGFloat cellHeight = 50;
static CGFloat borderMargin = 10;
static CGFloat contentLabelWidth = 200;

static NSInteger fontSize = 13;

@interface PopContentViewController ()
@property (weak) IBOutlet NSView *topView;
@property ( nonatomic, weak) NSTextField* startWorkTimeLabel;
@property ( nonatomic, weak) NSTextField* endWorkTimeLabel;

@property (weak) IBOutlet NSDatePicker *datePicker;
@property (weak) IBOutlet NSButton *changeTimeButton;

@property ( nonatomic, strong) SettingWindowController* settingWin;
@property ( nonatomic, strong) NSWindowController* aboutWin;

@end

@implementation PopContentViewController

- (void)loadView {
    self.view = [[NSView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];

    self.datePicker.alphaValue = 0.01;
    [self setMouseMoveMoniter];

    NSTimeInterval lastTime = [[[NSUserDefaults standardUserDefaults] objectForKey:LAST_OPEN_TIME] doubleValue];
    NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
    if (lastTime > 0) {
        self.datePicker.dateValue = lastDate;
    }
}


- (void)setMouseMoveMoniter {
    self.topView.layer.backgroundColor = [NSColor clearColor].CGColor;
    [self.topView setNeedsDisplay:YES];
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:CGRectZero
                                                                options: (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                                                          NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved)
                                                                  owner:self
                                                               userInfo:nil];
    [self.topView addTrackingArea:trackingArea];
}

- (IBAction)showSettingWindow:(id)sender {
    NSStoryboard *board = [NSStoryboard storyboardWithName: @"SettingWindowController" bundle: nil];
    // SettingViewController
    SettingWindowController* settingWin = [board instantiateControllerWithIdentifier:@"SettingWindowController"];

    self.settingWin = settingWin;
    [settingWin.window makeKeyAndOrderFront:self];
    [settingWin.window center];
}

- (void)showAbout:(NSButton *)button {
    NSStoryboard *board = [NSStoryboard storyboardWithName: @"SettingWindowController" bundle: nil];
    NSWindowController* aboutWin = [board instantiateControllerWithIdentifier:@"AboutWindowController"];
    self.aboutWin = aboutWin;
    [aboutWin.window makeKeyAndOrderFront:self];
    [aboutWin.window center];
}


- (void)mouseEntered:(NSEvent *)event {
    self.changeTimeButton.hidden = NO;
}
- (void)mouseExited:(NSEvent *)event {
    self.changeTimeButton.hidden = YES;
    
    self.changeTimeButton.state = 0;
    self.changeTimeButton.title = @"修改";
    [self topNarmalState];
}

- (IBAction)changeButtonPressed:(NSButton *)sender {
    NSLog(@"sender: %zd", sender.state);
    sender.title = sender.state ? @"完成" : @"修改";
    if (sender.state) {
        
        [self topChangeState];
    }else {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:[self.datePicker.dateValue timeIntervalSince1970]] forKey:LAST_OPEN_TIME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CFNotifyHandleTool* handleTool = [CFNotifyHandleTool sharedInstance];
        [handleTool setNotificationWithStartDate:self.datePicker.dateValue popVC:self];
        [self topNarmalState];
    }

}

- (void)topNarmalState {
    self.datePicker.alphaValue = 0.01;
    self.changeTimeButton.hidden = YES;
    self.startWorkTimeLabel.hidden = NO;
}

- (void)topChangeState {
    self.datePicker.alphaValue = 1;
    self.changeTimeButton.hidden = NO;
    self.startWorkTimeLabel.hidden = YES;
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    self.endWorkTimeLabel.stringValue = self.endTimeStr ? : @"0";
    self.startWorkTimeLabel.stringValue = self.timeStr ? : @"0";
}


- (void)setEndTimeStr:(NSString *)endTimeStr {
    _endTimeStr = endTimeStr;
    self.endWorkTimeLabel.stringValue = endTimeStr ? : @"0";
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    self.startWorkTimeLabel.stringValue = timeStr ? : @"0";
}

- (void)setupSubViews {
    
    // top
    NSView* topView = [[NSView alloc] init];
    [self.view addSubview:topView];
    self.topView = topView;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(cellHeight);
    }];
    
    NSBox* topLineView = [[NSLineView alloc] init];
    [topView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.equalTo(1);
    }];

    NSTextField* startWorkLabel = [NSLabel textFieldWithString:@"上班时间: "];
    [topView addSubview:startWorkLabel];
    [startWorkLabel sizeToFit];
    startWorkLabel.font = [NSFont systemFontOfSize:fontSize];
    startWorkLabel.textColor = [NSColor redColor];
    [startWorkLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(borderMargin);
    }];

    NSTextField* startWorkTimeLabel = [NSLabel textFieldWithString:@"0"];
    self.startWorkTimeLabel = startWorkTimeLabel;
    [topView addSubview:startWorkTimeLabel];
    startWorkTimeLabel.font = [NSFont systemFontOfSize:fontSize];
    [startWorkTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startWorkLabel);
        make.left.equalTo(startWorkLabel.right).offset(borderMargin);
        make.width.equalTo(contentLabelWidth);
    }];
    
    NSDatePicker* datePicker = [[NSDatePicker alloc] init];
    self.datePicker = datePicker;
    datePicker.datePickerStyle = NSTextFieldDatePickerStyle;
    datePicker.datePickerElements = NSHourMinuteDatePickerElementFlag | NSYearMonthDayDatePickerElementFlag;
    [topView addSubview:datePicker];
    [datePicker makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startWorkTimeLabel);
        make.centerY.equalTo(topView);
    }];

    
    
    // middle
    NSView* middleView = [[NSView alloc] init];
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topView.bottom);
        make.height.equalTo(cellHeight);
    }];
    
    NSLineView* bottomLineView = [[NSLineView alloc] init];
    [middleView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(middleView);
        make.height.equalTo(1);
    }];
    
    NSTextField* endWorkLabel = [NSLabel textFieldWithString:@"下班时间: "];
    [middleView addSubview:endWorkLabel];
    [endWorkLabel sizeToFit];
    endWorkLabel.font = [NSFont systemFontOfSize:fontSize];
    endWorkLabel.textColor = [NSColor greenColor];
    [endWorkLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(middleView);
        make.left.equalTo(middleView).offset(borderMargin);
    }];
    
    NSTextField* endWorkTimeLabel = [NSLabel textFieldWithString:@"0"];
    self.endWorkTimeLabel = endWorkTimeLabel;
    [middleView addSubview:endWorkTimeLabel];
    endWorkTimeLabel.font = [NSFont systemFontOfSize:fontSize];
    [endWorkTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endWorkLabel);
        make.left.equalTo(endWorkLabel.right).offset(borderMargin);
        make.width.equalTo(contentLabelWidth);
    }];

    // bottom
    NSButton* aboutButton = [NSButton buttonWithTitle:@"关于" target:self action:@selector(showAbout:)];
    [self.view addSubview:aboutButton];
    [aboutButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(borderMargin);
        make.bottom.equalTo(self.view).offset(-borderMargin);
        make.size.equalTo(CGSizeMake(50, 20));
    }];
    
    NSButton* settingButton = [NSButton buttonWithTitle:@"设置" target:self action:@selector(showSettingWindow:)];
    [self.view addSubview:settingButton];
    [settingButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-borderMargin);
        make.bottom.equalTo(self.view).offset(-borderMargin);
        make.size.equalTo(aboutButton);
    }];
    
    NSButton* changeTimeButton = [NSButton buttonWithTitle:@"修改" target:self action:@selector(changeButtonPressed:)];
    changeTimeButton.hidden = YES;
    self.changeTimeButton = changeTimeButton;
    [topView addSubview:changeTimeButton];
    [changeTimeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startWorkLabel);
        make.centerX.equalTo(settingButton);
        make.size.equalTo(aboutButton);
    }];

}

@end
