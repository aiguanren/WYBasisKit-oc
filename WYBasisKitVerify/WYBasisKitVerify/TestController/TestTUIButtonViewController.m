//
//  TestTUIButtonViewController.m
//  WYBasisKit
//
//  Created by  guanren on 2018/6/22.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "TestTUIButtonViewController.h"
@import WYBasisKit_oc;

@interface TestTUIButtonViewController ()

@end

@implementation TestTUIButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, wy_navViewHeight+50, wy_screenWidth-40, 100);
    btn.backgroundColor = [UIColor orangeColor];
    btn.wy_titleFont = [UIFont boldSystemFontOfSize:25];
    btn.wy_nTitle = @"默认状态";
    btn.wy_hTitle = @"高亮状态";
    btn.wy_sTitle = @"选中状态";
    btn.wy_title_nColor = [UIColor greenColor];
    btn.wy_title_hColor = [UIColor yellowColor];
    btn.wy_title_sColor = [UIColor blackColor];
    btn.wy_nImage = [UIImage wy_cutImage:[UIImage imageNamed:@"timg-n"] andSize:CGSizeMake(50, 50)];
    btn.wy_hImage = [UIImage wy_cutImage:[UIImage imageNamed:@"timg-h"] andSize:CGSizeMake(50, 50)];
    btn.wy_sImage = [UIImage wy_cutImage:[UIImage imageNamed:@"timg-s"] andSize:CGSizeMake(50, 50)];
    
    CGSize titleSize = [btn.titleLabel.text wy_boundingRectWithSize:btn.wy_size withFont:btn.wy_titleFont lineSpacing:0];
    CGSize imageSize = CGSizeMake(50, 50);
    
    // 通过运行时设置图片控件与文本控件的位置
    btn.wy_titleRect = CGRectMake(10, (btn.wy_height-imageSize.height-titleSize.height-5)/2, titleSize.width, titleSize.height);
    btn.wy_imageRect = CGRectMake(110, 10, imageSize.width, imageSize.height);
    [btn wy_addTarget:self selector:@selector(btnClick:)];
    
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(20, wy_navViewHeight+200, wy_screenWidth-40, 120);
    btn2.backgroundColor = [UIColor redColor];
    btn2.wy_titleFont = [UIFont boldSystemFontOfSize:25];
    btn2.wy_nTitle = @"默认状态";
    btn2.wy_title_nColor = [UIColor greenColor];
    btn2.wy_nImage = [UIImage wy_cutImage:[UIImage imageNamed:@"timg-n"] andSize:CGSizeMake(20, 30)];
    [btn2 wy_addTarget:self selector:@selector(btnClick:)];
    
    //通过EdgeInsets设置图片控件与文本控件的位置
    [btn2 wy_adjustWithPosition:WYButtonPositionImageBottomTitleTop spacing:10];
    
    [self.view addSubview:btn2];
}

- (void)btnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSLog(@"sender:%@",sender);
    NSLog(@"nTitle = %@\nhTitle = %@\nsTitle = %@",sender.wy_nTitle,sender.wy_hTitle,sender.wy_sTitle);
    NSLog(@"title_nColor = %@\ntitle_hColor = %@\ntitle_sColor = %@",sender.wy_title_nColor,sender.wy_title_hColor,sender.wy_title_sColor);
    NSLog(@"nImage = %@\nhImage = %@\nsImage = %@",sender.wy_nImage,sender.wy_hImage,sender.wy_sImage);
    
    if (sender.selected == YES) {
        [[WYEventHandler shared] responseEvent:@"AppEventButtonDidSelected" data:sender.wy_sTitle];
    }else {
        [[WYEventHandler shared] responseEvent:@"AppEventButtonRestoreDefault" data:sender.wy_nTitle];
    }
}

- (void)dealloc {
    
    NSLog(@"dealloc");
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
