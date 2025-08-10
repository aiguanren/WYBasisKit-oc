//
//  WYAttributedController.m
//  WYBasisKitVerify
//
//  Created by 官人 on 2025/7/7.
//

#import "WYAttributedController.h"
#import <Masonry/Masonry.h>
@import WYBasisKitOC;

@interface WYAttributedController ()

@end

@implementation WYAttributedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"测试1\n测试2\n测试3\n测试4"];
    [attributed wy_setLineSpacings:10 beforeString:@"测试1" afterString:@"测试2" alignment:NSTextAlignmentLeft];
    [attributed wy_setLineSpacings:15 beforeString:@"测试2" afterString:@"测试3" alignment:NSTextAlignmentLeft];
    [attributed wy_setLineSpacings:20 beforeString:@"测试3" afterString:@"测试4" alignment:NSTextAlignmentLeft];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor orangeColor];
    label.numberOfLines = 0;
    label.attributedText = attributed;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).mas_offset(20);
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
