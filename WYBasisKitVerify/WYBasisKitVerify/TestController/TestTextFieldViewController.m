//
//  TestTextFieldViewController.m
//  WYBasisKit
//
//  Created by  guanren on 2018/6/22.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "TestTextFieldViewController.h"
@import WYBasisKitOC;

@interface TestTextFieldViewController ()

@end

@implementation TestTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //全局收起键盘
    [self.navigationController.view wy_gestureHidingkeyboard];
    
    UIView *superView = [UIView wy_createViewWithFrame:CGRectMake(0, 0, wy_screenWidth, wy_screenHeight-200) color:[UIColor redColor]];
    [self.view addSubview:superView];
    
    UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(20, wy_screenHeight-60-wy_navViewHeight, wy_screenWidth-40, 50)];
    textField1.placeholder = @"这个是加载在控制器view上的";
    textField1.wy_placeholderColor = [UIColor orangeColor];
    textField1.backgroundColor = [UIColor greenColor];
    [textField1 wy_automaticFollowKeyboard:self.view];
    [textField1 wy_textDidChange:^(NSString *textStr) {

        NSLog(@"输入的文本是：%@",textStr);
    }];
    [textField1 wy_fixMessyDisplay];
    [self.view addSubview:textField1];
    
    UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(20, superView.wy_bottom-60, wy_screenWidth-40, 50)];
    textField2.placeholder = @"这个是加载在子view上的,5个字符";
    textField2.backgroundColor = [UIColor greenColor];
    [textField2 wy_automaticFollowKeyboard:self.view];
    textField2.wy_maximumLimit = 5;
    [textField2 wy_textDidChange:^(NSString *textStr) {

        NSLog(@"输入的文本是：%@",textStr);
    }];
    [superView addSubview:textField2];
}

- (void)dealloc {
    
    NSLog(@"dealloc");
    [self.view wy_releaseKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
