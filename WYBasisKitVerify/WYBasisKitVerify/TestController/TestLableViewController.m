//
//  TestLableViewController.m
//  WYBasisKit
//
//  Created by  guanren on 2018/6/20.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "TestLableViewController.h"
#import "UILabel+WYRichText.h"
#import "NSMutableParagraphStyle+WYExtension.h"
#import "NSMutableAttributedString+WYExtension.h"
@import WYBasisKit_oc;

@interface TestLableViewController ()<WYRichTextDelegate>

@end

@implementation TestLableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lab = [UILabel wy_createLabWithFrame:CGRectMake(20, 0, wy_screenWidth-40, 0) textColor:[UIColor blackColor] font:wy_boldFont(15)];
    lab.text = [self testStr];
    lab.backgroundColor = [UIColor lightGrayColor];
    lab.numberOfLines = 0;

    //快速创建富文本属性
    NSMutableAttributedString *attribute = [NSMutableAttributedString wy_attributeWithStr:lab.text];
    //设置行间距
    [attribute wy_setLineSpacing:20 string:@"治性之道，必审己之所有余而强其所不足，盖聪明疏通者戒于太察"];
    [attribute wy_setLineSpacing:50 string:@"勇猛刚强者戒于太暴，仁爱温良者戒于无断，湛静安舒者戒于后时"];
    //设置字间距
    [attribute wy_setWordsSpacing:20 string:@"然后中和之化应"];

    //通过传入要设置的文本设置文本颜色
    NSArray *colorsOfRanges = @[@{[UIColor orangeColor]:@"治性之道"},@{[UIColor greenColor]:@"盖聪明疏通者戒于太察"}];
    [attribute wy_colorsOfRanges:colorsOfRanges];

    //通过传入要设置的文本和传入要设置文本的下标位置综合设置文本字号
    NSArray *fontsOfRanges = @[@{[UIFont systemFontOfSize:18]:@"广心浩大者戒于遗忘"},@{[UIFont boldSystemFontOfSize:30]:@[@"1",@"2"]}];
    [attribute wy_fontsOfRanges:fontsOfRanges];

    //设置标签的富文本为自定义的富文本属性
    lab.attributedText = attribute;

    [lab sizeToFit];
    [self.view addSubview:lab];


    //富文本点击
    //需要点击的字符相同
    NSString *label_text1 = @"我是个抽奖Label， 点我有奖，点我没奖哦";

    NSMutableAttributedString *attributedString1 = [NSMutableAttributedString wy_attributeWithStr:label_text1];

    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, label_text1.length)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12, 2)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(17, 2)];

    NSMutableParagraphStyle *sty = [NSMutableParagraphStyle wy_paragraphStyle];
    sty.alignment = NSTextAlignmentCenter;
    sty.lineSpacing = 5;
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, label_text1.length)];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, lab.wy_bottom+50, self.view.bounds.size.width - 20, 60)];
    label1.backgroundColor = [UIColor yellowColor];
    label1.numberOfLines = 2;
    //设置点击效果颜色 默认lightGrayColor
    label1.wy_clickEffectColor = [UIColor greenColor];
    label1.attributedText = attributedString1;
    [self.view addSubview:label1];

    //通过代理设置要点击的字符串
    [label1 wy_clickRichTextWithStrings:@[@"点我",@"点我"] delegate:self];

    //需要点击的字符不同
    NSString *label_text2 = @"您好！您是小明吗？你中奖了，领取地址“https://github.com/guanren/WYBasisKit”,领奖码“记得给star哦”";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(19, 38)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(63, 8)];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, label1.wy_bottom+50, self.view.bounds.size.width - 20, 180)];
    label2.backgroundColor = [UIColor greenColor];
    label2.numberOfLines = 3;
    label2.attributedText = attributedString2;
    [self.view addSubview:label2];

    //通过block设置要点击的字符串
    wy_weakSelf(self);
    [label2 wy_clickRichTextWithStrings:@[@"https://github.com/guanren/WYBasisKit",@"记得给star哦"] clickAction:^(NSString *string, NSRange range, NSInteger index) {
        NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),(long)index];
        NSLog(@"messge = %@",message);
        [weakself showAlertMessage:message];
    }];
    //设置是否有点击效果，默认是YES
    label2.wy_enabledClickEffect = NO;
}

- (NSString *)testStr {
    
    return @"治性之道，必审己之所有余而强其所不足，盖聪明疏通者戒于太察，寡闻少见者戒于壅蔽，勇猛刚强者戒于太暴，仁爱温良者戒于无断，湛静安舒者戒于后时，广心浩大者戒于遗忘。必审己之所当戒而齐之以义，然后中和之化应，而巧伪之徒不敢比周而望进。";
}

- (void)wy_didClickRichText:(NSString *)string range:(NSRange)range index:(NSInteger)index {
    
    NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),(long)index];
    NSLog(@"messge = %@",message);
    [self showAlertMessage:message];
}

- (void)showAlertMessage:(NSString *)message {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [actionSheet addAction:albumAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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
