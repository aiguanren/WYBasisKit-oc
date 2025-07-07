//
//  MainViewController.m
//  WYBasisKit
//
//  Created by  guanren on 2018/6/19.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "MainViewController.h"
#import "NSString+WYExtension.h"
#import "UITableViewCell+WYExtension.h"
@import WYBasisKit_oc;

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    //设置标题颜色
    self.navigationController.wy_titleColor = [UIColor yellowColor];
    //设置标题字号
    self.navigationController.wy_titleFont = [UIFont boldSystemFontOfSize:30];
    //设置导航栏背景图
    //self.navigationController.wy_barBackgroundImage = [UIImage imageNamed:@"test"];
    //设置导航栏背景颜色(设置了背景图就不用设置背景颜色了)
    self.navigationController.wy_barBackgroundColor = [UIColor greenColor];
    //设置导航栏返回按钮图片
    self.navigationController.wy_barReturnButtonImage = [UIImage imageNamed:@"返回按钮"];
    //设置导航栏返回按钮文字颜色
    self.navigationController.wy_barReturnButtonColor = [UIColor orangeColor];
    //设置跳转到下一页时返回文本(可以传空)
    [self.navigationController wy_pushControllerBarReturnButtonTitle:@"回首页" navigationItem:self.navigationItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell wy_cellCutOffLineFromZeroPoint];
        cell.wy_rightArrowImage = [UIImage imageNamed:@"jiantou"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [self section][indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[NSClassFromString([self controllers][indexPath.row]) alloc] init];;
    vc.navigationItem.title = [self section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)section {
    
    NSArray *sectionTitleAry = @[@"WKWebView",@"UILable",@"UITextView",@"UITextField",@"UIButton",@"BoolJudge",@"LoadingState",@"userAvatar",@"pagingView",@"UIAlert", @"根据类名跨类调用方法", @"圆角、边框、阴影、渐变", @"归档解归档", @"富文本"];
    
    return sectionTitleAry;
}

- (NSArray <NSString *> *)controllers {
    return @[@"TestWebViewViewController",
             @"TestLableViewController",
             @"TestTextViewViewController",
             @"TestTextFieldViewController",
             @"TestTUIButtonViewController",
             @"TestBoolJudgeViewController",
             @"TestLoadingStateViewController",
             @"TestUserAvatarViewController",
             @"TestPagingViewController",
             @"TestUIAlertController",
             @"TestCallMethodController",
             @"WYTestVisualController",
             @"WYArchivedController",
             @"WYAttributedController"];
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, wy_screenWidth, wy_screenHeight-wy_navViewHeight) style:UITableViewStyleGrouped];
        tableview.delegate = self;
        tableview.dataSource = self;
        [tableview wy_forbiddenSelfSizing];
        tableview.tableFooterView = [[UIView alloc]init];
        
        [self.view addSubview:tableview];
        
        _tableView = tableview;
    }
    
    return _tableView;
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
