//
//  WYTestVisualController.m
//  WYBasisKit
//
//  Created by 官人 on 2020/12/12.
//  Copyright © 2020 官人. All rights reserved.
//

#import "WYTestVisualController.h"
#import <Masonry/Masonry.h>

@interface WYTestVisualController ()

@end

@implementation WYTestVisualController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UIView *lineView1 = [self createLineView];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(self.view).mas_offset(wy_navViewHeight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    UIView *lineView2 = [self createLineView];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(lineView1);
        make.right.equalTo(self.view).mas_offset(-220);
    }];
    
    UIView *lineView3 = [self createLineView];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(200);
        make.height.mas_offset(1);
    }];
    
    UIView *lineView4 = [self createLineView];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lineView3);
        make.top.equalTo(self.view).offset(300);
    }];
    
    UIView *lineView5 = [self createLineView];
    [lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lineView3);
        make.top.equalTo(self.view).offset(350);
    }];
    
    UIView *lineView6 = [self createLineView];
    [lineView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(lineView1);
        make.right.equalTo(self.view).offset(-120);
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button1];
    [button1 wy_setBackgroundColor:[UIColor orangeColor] state:UIControlStateNormal];
    button1.titleLabel.numberOfLines = 0;
    [button1 setTitle:@"frame控件" forState:UIControlStateNormal];
    button1.wy_borderWidth(5).wy_borderColor([UIColor yellowColor]).wy_rectCorner(UIRectCornerBottomLeft | UIRectCornerTopRight).wy_cornerRadius(10).wy_shadowRadius(20).wy_shadowColor([UIColor greenColor]).wy_shadowOpacity(0.5).wy_showVisual();
    button1.frame = CGRectMake(20, 200, 100, 100);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(updateButtonConstraints:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.numberOfLines = 0;
    [button setTitle:@"约束控件" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.wy_makeVisual(^(UIView * _Nonnull make) {
        make.wy_gradualColors(@[[UIColor yellowColor], [UIColor purpleColor]]);
        make.wy_gradientDirection(leftToLowRight);
        make.wy_borderWidth(5);
        make.wy_borderColor([UIColor blackColor]);
        make.wy_rectCorner(UIRectCornerTopRight);
        make.wy_cornerRadius(20);
        make.wy_shadowRadius(20);
        make.wy_shadowColor([UIColor greenColor]);
        make.wy_shadowOffset(CGSizeZero);
        make.wy_shadowOpacity(0.5);
        //make.wy_bezierPath([UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 50)]);
    });
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_offset(-20);
        make.top.equalTo(self.view).mas_offset(200);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UIView *gradualView = [[UIView alloc] init];
    gradualView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:gradualView];
    [gradualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(20);
        make.top.equalTo(self.view).mas_offset(500);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    gradualView.wy_rectCorner(UIRectCornerAllCorners);
    gradualView.wy_cornerRadius(10);
    gradualView.wy_borderColor([UIColor blackColor]);
    gradualView.wy_borderWidth(5);
    gradualView.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]);
    gradualView.wy_gradientDirection(leftToRight);
    gradualView.wy_showVisual();
}

- (void)updateButtonConstraints:(UIButton *)button {
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_offset(-20);
        make.top.equalTo(self.view).mas_offset(200);
        make.size.mas_equalTo(CGSizeMake(200, 150));
    }];
    button.wy_makeVisual(^(UIView * _Nonnull make) {
        make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]);
        make.wy_gradientDirection(topToBottom);
        make.wy_borderWidth(10);
        make.wy_borderColor([UIColor purpleColor]);
        make.wy_rectCorner(UIRectCornerTopLeft);
        make.wy_cornerRadius(30);
        make.wy_shadowRadius(10);
        make.wy_shadowColor([UIColor redColor]);
        make.wy_shadowOffset(CGSizeZero);
        make.wy_shadowOpacity(0.5);
    });
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = wy_randomColor;
    [self.view addSubview:lineView];
    return lineView;
}

- (void)dealloc {
    NSLog(@"WYTestVisualController release");
}

@end
