//
//  TestUIAlertController.m
//  WYBasisKit
//
//  Created by bangtuike on 2019/6/28.
//  Copyright © 2019 guanren. All rights reserved.
//

#import "TestUIAlertController.h"
#import "UIViewController+WYAlert.h"
#import "NSMutableAttributedString+WYExtension.h"
@import WYBasisKit_oc;

@interface TestUIAlertController ()

@end

@implementation TestUIAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat btnWidth = (wy_screenWidth-64)/3;
    CGFloat leftx = 16;
    CGFloat topy = 100;
    for (int i=0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftx, topy, btnWidth, 50);
        btn.wy_nTitle = @[@"alert",@"actionSheet",@"弹窗模式"][i];
        btn.backgroundColor = [UIColor orangeColor];
        btn.wy_title_nColor = [UIColor whiteColor];
        btn.tag = i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
        leftx = btn.wy_right+16;
    }
}

- (void)showAlert:(UIButton *)sender {
    
    if(sender.tag < 2) {
        self.wy_preferredStyle = sender.tag;
    }
    //self.wy_clickBlankClose = NO;
    self.wy_alertTitleColor = [UIColor orangeColor];
    self.wy_alertTitleFont = [UIFont boldSystemFontOfSize:30];
    self.wy_alertMessageColor = [UIColor greenColor];
    self.wy_alertMessageFont = [UIFont systemFontOfSize:18];
    self.wy_cancelActionColor = [UIColor orangeColor];
    self.wy_otherActionColor = [UIColor purpleColor];
    self.wy_actionTitleColors = @[[NSNull class],[UIColor blueColor],[UIColor purpleColor]];
    
    NSString *title = @"标题";
    NSString *message = @"消息";
    NSArray *actionTitleOne = @[@"按钮0"];
    NSArray *actionTitleTwo = @[@"按钮0",@"按钮1"];
    NSArray *actionTitleThree = @[@"取消",@"按钮1",@"按钮2"];
    
//    [self wy_showAlertControllerWithMessage:message];
    
//    [self wy_showAlertControllerWithAlertTitle:title alertMessage:message];

//    [self wy_showAlertControllerWithMessage:message actionTitles:actionTitleOne handler:^(UIAlertAction * _Nonnull alertAction, NSInteger actionIndex) {
//
//        NSLog(@"alertAction.title = %@\nactionIndex = %ld",alertAction.title,actionIndex);
//    }];
    [self wy_showAlertControllerWithAlertTitle:title alertMessage:message actionTitles:@[actionTitleTwo,actionTitleThree,actionTitleOne][sender.tag] handler:^(UIAlertAction * _Nonnull alertAction, NSInteger actionIndex) {

        NSLog(@"alertAction.title = %@\nactionIndex = %ld",alertAction.title,actionIndex);
        NSLog(@"title = %@  message = %@  actions = %@",self.wy_alertTitle,self.wy_alertMessage,self.wy_actionTitles);
    }];
    
//    NSMutableAttributedString *attributedTitle = [NSMutableAttributedString wy_attributeWithStr:title];
//    NSArray *colorsOfRanges = @[@{[UIColor greenColor]:@"标"},@{[UIColor blueColor]:@"题"}];
//    NSArray *fontsOfRanges = @[@{[UIFont boldSystemFontOfSize:20]:@"标"},@{[UIFont boldSystemFontOfSize:10]:@"题"}];
//    [attributedTitle wy_fontsOfRanges:fontsOfRanges];
//    [attributedTitle wy_colorsOfRanges:colorsOfRanges];
//
//    NSMutableAttributedString *attributedMessage = [NSMutableAttributedString wy_attributeWithStr:message];
//    NSArray *mecolorsOfRanges = @[@{[UIColor blackColor]:@"消"},@{[UIColor orangeColor]:@"息"}];
//    NSArray *mefontsOfRanges = @[@{[UIFont systemFontOfSize:20]:@"消"},@{[UIFont systemFontOfSize:15]:@"息"}];
//    [attributedMessage wy_setWordsSpacing:10 string:attributedMessage.string];
//    [attributedMessage wy_addUnderlineWithString:attributedMessage.string];
//    [attributedMessage wy_fontsOfRanges:mefontsOfRanges];
//    [attributedMessage wy_colorsOfRanges:mecolorsOfRanges];
//
//    [self wy_showAlertControllerWithAlertAttributedTitle:attributedTitle alertMessage:attributedMessage actionTitles:actionTitleTwo handler:^(UIAlertAction * _Nonnull alertAction, NSInteger actionIndex) {
//        NSLog(@"alertAction.title = %@\nactionIndex = %ld",alertAction.title,actionIndex);
//        NSLog(@"title = %@  message = %@  actions = %@",self.wy_alertTitle,self.wy_alertMessage,self.wy_actionTitles);
//    }];
}

- (void)dealloc {
    
    NSLog(@"控制器已释放");
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
