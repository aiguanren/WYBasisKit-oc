//
//  TestLoadingStateViewController.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/7/18.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "TestLoadingStateViewController.h"
#import "UITextField+WYExtension.h"
#import "UITableViewCell+WYExtension.h"
@import WYBasisKit_oc;

@interface TestLoadingStateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) NSInteger superViewIndex;

@end

@implementation TestLoadingStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //全局收起键盘
    [self.navigationController.view wy_gestureHidingkeyboard];
    
    UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, wy_screenWidth-40, 50)];
    textField1.placeholder = @"请输入要显示的文本";
    //textField1.wy_placeholderColor = [UIColor orangeColor];
    textField1.backgroundColor = [UIColor greenColor];
    textField1.tag = 100;
//    [textField1 wy_automaticFollowKeyboard:self.view];
//    [textField1 wy_textDidChange:^(NSString *textStr) {
//
//        NSLog(@"输入的文本是：%@",textStr);
//    }];
    //[textField1 wy_fixMessyDisplay];
    [self.view addSubview:textField1];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self section].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *rowAry = [self row][section];
    return rowAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self section][section];
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
        [cell wy_cellCutOffLineFromZeroPoint];
    }
    NSArray *rowAry = [self row][indexPath.section];
    cell.textLabel.text = rowAry[indexPath.row];
    
    for (UIView *cellSubView in cell.contentView.subviews) {
        
        if([cellSubView isKindOfClass:[UIButton class]]) {
            
            [cellSubView removeFromSuperview];
            break;
        }
    }

    if(indexPath.section > 2) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(wy_screenWidth-50, 12.5, 30, 30);
        btn.wy_nImage = [UIImage imageNamed:@"对勾-2"];
        btn.wy_sImage = [UIImage imageNamed:@"对勾"];
        if(indexPath.section == 3) {
            
            btn.selected = (indexPath.row == _superViewIndex);
        }
        [cell.contentView addSubview:btn];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIButton *btn = [self cellBtnWithIndexPath:indexPath];
    btn.wy_nImage = [[UIImage alloc]init];
    btn.wy_sImage = [[UIImage alloc]init];
    if(indexPath.section == 3) {
        
        btn.wy_nImage = [UIImage imageNamed:@"对勾-2"];
        btn.wy_sImage = [UIImage imageNamed:@"对勾"];
        btn.selected = (indexPath.row == _superViewIndex);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[LoadingView userInteractionEnabled:NO];
    UITextField *textField = [self.view viewWithTag:100];
    if(indexPath.section == 0) {
        
        if(indexPath.row == 0) {
            
            if(_superViewIndex == 0) {
                
                [LoadingView showMessage:textField.text];
                
            }else {
                
                [LoadingView showMessage:textField.text superView:self.view];
            }
            
        }else {
            
            if(_superViewIndex == 0) {
                
                [LoadingView showInfo:textField.text];
                
            }else {
                
                [LoadingView showInfo:textField.text superView:self.view];
            }
        }
    }
    else if (indexPath.section == 1) {
        
        if(indexPath.row == 0) {
            
            [StateView showSuccessInfo:textField.text];
        }
        else if (indexPath.row == 1) {
            
            [StateView showErrorInfo:textField.text];
        }
        else {
            
            [StateView showWarningInfo:textField.text];
        }
    }
    else if (indexPath.section == 2) {
        
        if(indexPath.row == 0) {
            
            [LoadingView dismiss];
        }
        else {
            
            [StateView dismiss];
        }
    }
    else if (indexPath.section == 3) {
        
        UIButton *btn = [self cellBtnWithIndexPath:[NSIndexPath indexPathForRow:_superViewIndex inSection:indexPath.section]];
        if(indexPath.row != _superViewIndex) {
            
            btn.selected = NO;
            btn = [self cellBtnWithIndexPath:indexPath];
            btn.selected = YES;
            self.superViewIndex = indexPath.row;
        }
    }
}

- (UIButton *)cellBtnWithIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = nil;
    for (UIView *cellSubView in cell.contentView.subviews) {
        
        if([cellSubView isKindOfClass:[UIButton class]]) {
            
            btn = (UIButton *)cellSubView;
            break;
        }
    }
    
    return btn;
}

- (NSArray *)section {
    
    NSArray *sectionTitleAry = @[@"LoadingView",@"StateView",@"dismiss",@"superView(仅LoadingView)"];
    
    return sectionTitleAry;
}

- (NSArray *)row {
    
    NSArray *rowTitleAry = @[@[@"自定义图片",@"系统小菊花"],@[@"成功",@"失败",@"警告"],@[@"LoadingView  dismiss",@"StateView  dismiss"],@[@"自动寻找控制器view  ||  keyWindow",@"自己传入"]];
    
    return rowTitleAry;
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, wy_screenWidth, wy_screenHeight-wy_navViewHeight-80) style:UITableViewStyleGrouped];
        tableview.delegate = self;
        tableview.dataSource = self;
        [tableview wy_forbiddenSelfSizing];
        tableview.tableFooterView = [[UIView alloc]init];
        
        self.superViewIndex = 0;
        
        [self.view addSubview:tableview];
        
        _tableView = tableview;
    }
    
    return _tableView;
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
