//
//  TestPagingViewController.m
//  WYBasisKit
//
//  Created by guanren on 2019/6/7.
//  Copyright © 2019 guanren. All rights reserved.
//

#import "TestPagingViewController.h"
@import WYBasisKitOC;

@interface TestPagingViewController ()

@end

@implementation TestPagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WYPagingView *pagingView = [[WYPagingView alloc]wy_initWithFrame:CGRectMake(0, 0, wy_screenWidth, wy_screenHeight-wy_navViewHeight) superViewController:self];
//    pagingView.bar_Height = 80;
//    pagingView.bar_Width = 120;
//    pagingView.barButton_dividingSpace = 10;
//    pagingView.bar_bg_defaultColor = [UIColor orangeColor];
//    pagingView.bar_bg_selectedColor = [UIColor greenColor];
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:0];
    NSArray *titleAry = @[@"喜欢斗地主",@"弄啥呢"];
    NSMutableArray *deImages = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *slImages = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<titleAry.count; i++) {
        
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = wy_randomColor;
        [vcs addObject:vc];
        [deImages addObject:@"shengxian-shuiguo"];
        [slImages addObject:@"shuiguopingguo"];
    }
    //[pagingView wy_layoutPagingControllerAry:[vcs copy] titleAry:[titleAry copy] defaultImageAry:[deImages copy] selectedImageAry:[slImages copy]];
    [pagingView wy_layoutPagingControllerAry:[vcs copy] titleAry:[titleAry copy]];
    [self.view addSubview:pagingView];
    pagingView.bar_badgeValueOffset = CGPointMake(5, 0);
    [pagingView wy_showBadge:YES value:@"1" atIndex:2];
    
    [pagingView wy_scrollPagingToIndex:^(NSInteger pagingIndex) {
        
//        if(pagingIndex == 2) {
//            [pagingView wy_showBadge:NO value:@"" atIndex:2];
//        }
    }];
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
