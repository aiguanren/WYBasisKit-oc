//
//  WYLogController.m
//  WYBasisKitVerify
//
//  Created by guanren on 2025/7/26.
//

#import "WYLogController.h"
@import WYBasisKit_oc;

@interface WYLogController ()

@end

@implementation WYLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    WYLogManager.clearLogFile();
    
    WYLogManager.outputWithMode(AlwaysConsoleOnly, @"非宏定义方法调用", [NSString stringWithUTF8String:__FILE__], [NSString stringWithUTF8String:__FUNCTION__], __LINE__);
    
    NSLog(@"不保存日志，仅在 DEBUG 模式下输出到控制台（默认）");
    
    NSLogWithMode(AlwaysConsoleOnly, @"不保存日志，DEBUG 和 RELEASE 都输出到控制台");
    
    NSLogWithMode(DebugConsoleAndFile, @"保存日志，仅在 DEBUG 模式下输出到控制台");
    
    NSLogWithMode(AlwaysConsoleAndFile, @"保存日志，DEBUG 和 RELEASE 都输出到控制台");
    
    NSLogWithMode(OnlySaveToFile, @"仅保存日志，DEBUG 和 RELEASE 均不输出到控制台");
    
    NSLog(@"eventHandlers = %@",[WYEventHandler shared].eventHandlers);
    
    [[WYEventHandler shared] removeEvent:@"AppEventButtonRestoreDefault" target:nil];
    
    [WYLogManager showPreview];
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
