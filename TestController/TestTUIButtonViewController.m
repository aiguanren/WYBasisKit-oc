//
//  TestTUIButtonViewController.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/22.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "TestTUIButtonViewController.h"
#import "UIImage+wyExtension.h"
#import "UIButton+WYEdgeInsets.h"

@interface TestTUIButtonViewController ()

@end

@implementation TestTUIButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn    = [[UIButton alloc]wy_initWithFrame:CGRectMake(20, wy_navViewHeight+50, wy_screenWidth-40, 100) target:self selector:@selector(btnClick:)];
    btn.backgroundColor = [UIColor orangeColor];
    btn.wy_titleFont = [UIFont boldSystemFontOfSize:25];
    btn.wy_nTitle = @"默认状态";
    btn.wy_hTitle = @"高亮状态";
    btn.wy_sTitle = @"选中状态";
    btn.wy_title_nColor = [UIColor greenColor];
    btn.wy_title_hColor = [UIColor yellowColor];
    btn.wy_title_sColor = [UIColor blackColor];
    btn.wy_nImage = [UIImage imageNamed:@"timg-n"];
    btn.wy_hImage = [UIImage imageNamed:@"timg-h"];
    btn.wy_sImage = [UIImage imageNamed:@"timg-s"];
    
    CGSize titleSize = [btn.titleLabel.text wy_boundingRectWithSize:btn.wy_size withFont:btn.wy_titleFont lineSpacing:0];
    CGSize imageSize = CGSizeMake(50, 50);
    
    //通过运行时设置图片控件与文本控件的位置
    btn.wy_titleRect = CGRectMake((btn.wy_width-titleSize.width)/2, (btn.wy_height-imageSize.height-titleSize.height-5)/2, titleSize.width, titleSize.height);
    btn.wy_imageRect = CGRectMake((btn.wy_width-imageSize.width)/2, 5+titleSize.height+((btn.wy_height-imageSize.height-titleSize.height-5)/2), imageSize.width, imageSize.height);
    
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc]wy_initWithFrame:CGRectMake(20, wy_navViewHeight+200, wy_screenWidth-40, 120) target:self selector:@selector(btnClick:)];
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.wy_titleFont = [UIFont boldSystemFontOfSize:25];
    btn2.wy_nTitle = @"默认状态";
    btn2.wy_title_nColor = [UIColor greenColor];
    btn2.wy_nImage = [UIImage wy_cutImage:[UIImage imageNamed:@"timg-n"] andSize:CGSizeMake(20, 30)];
    
    //通过EdgeInsets设置图片控件与文本控件的位置
    [btn2 wy_layouEdgeInsetsPosition:WYButtonPositionImageTop_titleBottom spacing:10];
    
    [self.view addSubview:btn2];
}

- (void)btnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSLog(@"sender:%@",sender);
    NSLog(@"nTitle = %@\nhTitle = %@\nsTitle = %@",sender.wy_nTitle,sender.wy_hTitle,sender.wy_sTitle);
    NSLog(@"title_nColor = %@\ntitle_hColor = %@\ntitle_sColor = %@",sender.wy_title_nColor,sender.wy_title_hColor,sender.wy_title_sColor);
    NSLog(@"nImage = %@\nhImage = %@\nsImage = %@",sender.wy_nImage,sender.wy_hImage,sender.wy_sImage);
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
