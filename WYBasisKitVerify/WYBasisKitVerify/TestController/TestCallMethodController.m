//
//  TestCallMethodController.m
//  WYBasisKit
//
//  Created by zhanxun on 2024/5/13.
//  Copyright © 2024 guanren. All rights reserved.
//

#import "TestCallMethodController.h"

@protocol MethodClassHandleDelegate <NSObject>

@optional
- (void)CallMethodClassEventHandle:(NSString *_Nullable)responseData;

@end

@interface TestMethodSuperClass : NSObject

@property (nonatomic, weak) id<MethodClassHandleDelegate> delegate;

@end

@implementation TestMethodSuperClass

@end

@interface TestMethodClass : TestMethodSuperClass

@end

@implementation TestMethodClass

/// 无参数
- (void)testNoParameterMethod {
    NSLog(@"- (void)testNoParameterMethod called");
}

/// 有参数
- (void)testParameterMethod:(NSString *)parameter1 parameter2:(NSInteger)parameter2 {
    NSLog(@"- (void)testParameterMethod:(NSString *)parameter1 parameter2:(NSInteger)parameter2  called");
}

/// 有参数有返回值
- (NSString *)testParameterMethodWithReturnValue:(NSString *)parameter {
    NSLog(@"- (NSInteger)testParameterMethodWithReturnValue:(NSString *)parameter called");
    return @"通过return方式获取的返回值";
}

/// 有参数有返回值
- (void)testParameterMethodWithDelegate:(NSString *)parameter {
    NSLog(@"- (void)testParameterMethodWithDelegate:(NSString *)parameter called");
    if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(CallMethodClassEventHandle:)])) {
        [self.delegate CallMethodClassEventHandle:@"通过代理方式获取的返回值"];
    }
}

@end

@interface TestCallMethodController ()<MethodClassHandleDelegate>

@end

@implementation TestCallMethodController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 第一步，通过类名找到实例对象
    id methodClass = [[NSClassFromString(@"TestMethodClass") alloc] init];
    // 第二步，设置返回值监听代理(看具体是否有代理监听的需求)
    [methodClass setValue:self forKey:@"delegate"];
    
    // 第三步，根据方法名找到要调用的方法
    SEL selector1 = NSSelectorFromString(@"testNoParameterMethod");
    SEL selector2 = NSSelectorFromString(@"testParameterMethod:parameter2:");
    SEL selector3 = NSSelectorFromString(@"testParameterMethodWithReturnValue:");
    SEL selector4 = NSSelectorFromString(@"testParameterMethodWithDelegate:");
    IMP imp1 = [methodClass methodForSelector:selector1];
    IMP imp2 = [methodClass methodForSelector:selector2];
    IMP imp3 = [methodClass methodForSelector:selector3];
    IMP imp4 = [methodClass methodForSelector:selector4];

    // 第四步,调用对应方法、传参、获取返回值
    void(*function1)(id, SEL) = (void *)imp1;
    void(*function2)(id, SEL, NSString *, NSInteger) = (void *)imp2;
    NSString *(*function3)(id, SEL, NSString *) = (void *)imp3;
    void(*function4)(id, SEL, NSString *) = (void *)imp4;
    function1(methodClass, selector1);
    function2(methodClass, selector2, @"99999", 88888);
    NSString *responseData = function3(methodClass, selector3, @"99999");
    function4(methodClass, selector4, @"99999");
    
    NSLog(@"return：%@", responseData);
}

- (void)CallMethodClassEventHandle:(NSString *)responseData {
    NSLog(@"代理：%@",responseData);
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
