//
//  TestUserAvatarViewController.m
//  WYBasisKit
//
//  Created by  guanren on 2018/12/29.
//  Copyright © 2018 guanren. All rights reserved.
//

#import "TestUserAvatarViewController.h"
@import WYBasisKitOC;

@interface TestUserAvatarViewController ()

@end

@implementation TestUserAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat imageWidth = 60.f;
    CGFloat leftx = 20.f;
    CGFloat topy = 20.f;
    NSArray *nickNameAry = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"",@"_哈哈",@"哈哈——",@"哈哈_",@"哈嘿",@"嘿哈",@"哈嘿哦",@"哦嘿哈",@"😁",@"ok"];
    
    for (int i=0; i<nickNameAry.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftx, topy, imageWidth, imageWidth)];
        imageView.image = [UIImage wy_generateAvatarImageWithCharacter:nickNameAry[i] optional:nil];
        [self.view addSubview:imageView];
        
        leftx = (imageView.wy_right+20+imageWidth > wy_screenWidth-20) ? 20 : imageView.wy_right+20;
        topy = (imageView.wy_right+20+imageWidth > wy_screenWidth-20) ? imageView.wy_bottom+20 : imageView.wy_top;
    }
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
