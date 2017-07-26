//
//  AboutViewController.m
//  88-Mac通知
//
//  Created by 于传峰 on 2017/7/24.
//  Copyright © 2017年 于传峰. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak) IBOutlet NSTextField *verLabel;
@property (weak) IBOutlet NSTextField *bundleNameLabel;

@property (weak) IBOutlet NSTextField *rightLabel;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* verStr = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.verLabel.stringValue = [NSString stringWithFormat:@"版本 %@", verStr];
    
    NSString* rightStr = [[NSBundle mainBundle].infoDictionary objectForKey:@"NSHumanReadableCopyright"];
    self.rightLabel.stringValue = rightStr;
    
    NSString* nameStr = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"];
    self.bundleNameLabel.stringValue = nameStr;
}

@end
