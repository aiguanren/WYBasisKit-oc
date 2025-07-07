//
//  WYArchivedController.m
//  WYBasisKitVerify
//
//  Created by 官人 on 2025/7/7.
//

#import "WYArchivedController.h"
#import "NSObject+WYArchived.h"

@interface WYTestModel: NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) NSArray *nickNames;

@property (nonatomic, strong) NSDictionary *remarks;

@property (nonatomic, strong) id others;

@end

@implementation WYTestModel

@end

@interface WYArchivedModel: NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) NSArray *nickNames;

@property (nonatomic, strong) NSDictionary *remarks;

@property (nonatomic, strong) id others;

@end

@implementation WYArchivedModel

@end

@interface WYArchivedController ()

@end

@implementation WYArchivedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WYArchivedModel *model = [[WYArchivedModel alloc] init];
    model.name = @"用户名";
    model.age = 18;
    model.nickNames = @[@"昵称1", @"昵称2"];
    model.remarks = @{@"haha": @"嘿嘿"};
    
    WYTestModel *others = [[WYTestModel alloc] init];
    others.name = @"用户名";
    others.age = 19;
    others.nickNames = @[@"昵称1", @"昵称2"];
    others.remarks = @{@"heihei": @"嘿嘿"};
    
    model.others = others;
    
    NSString *archivedModelKey = @"ArchivedModelKey";
    
    NSData *data = [model wy_archivedData];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:archivedModelKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:archivedModelKey];
        if (data) {
            WYArchivedModel *unarchive = [WYArchivedModel wy_unarchiveFromData:archivedData];
            NSLog(@"解归档完毕：%@",unarchive);
        }
    });
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
