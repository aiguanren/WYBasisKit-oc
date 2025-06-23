//
//  TestBoolJudgeViewController.m
//  WYBasisKit
//
//  Created by  guanren on 2018/7/11.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "TestBoolJudgeViewController.h"
@import WYBasisKit_oc;

@interface TestBoolJudgeViewController ()

@end

@implementation TestBoolJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"是否包含Emoji = %@",[NSNumber numberWithBool:[@"fwet😁" wy_isIncludingEmoji]]);
    NSLog(@"是否包含Emoji = %@",[NSNumber numberWithBool:[@"😁" wy_isIncludingEmoji]]);
    NSLog(@"是否是Emoji = %@",[NSNumber numberWithBool:[@"😁" wy_isEmoji]]);
    NSLog(@"是否是Emoji = %@",[NSNumber numberWithBool:[@"j" wy_isEmoji]]);
    NSLog(@"查看Emoji = %@",@"fwet😁");
    NSLog(@"移除Emoji = %@",[@"fwet😁" wy_removedEmojiString]);
    NSLog(@"移除Emoji = %@",[@"fwet" wy_removedEmojiString]);
    NSLog(@"移除Emoji = %@",[@"fwet💕" wy_stringByReplacingEmojiCheatCodesWithUnicode]);
    NSLog(@"文字化Emoji = %@",[@"fwet💕" wy_stringByReplacingEmojiUnicodeWithCheatCodes]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
