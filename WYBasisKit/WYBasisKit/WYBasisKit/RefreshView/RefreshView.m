//
//  RefreshView.m
//  WYBasisKit
//
//  Created by jacke-xu on 17/2/23.
//  Copyright © 2017年 com.jacke-xu. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

+ (MJRefreshGifHeader *)refreshGifHeaderWithTarget:(id)target action:(SEL)selector {
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:selector];
    [header setImages:@[[UIImage imageNamed:@"pic_niuniu120"]] forState:MJRefreshStateIdle];
    [header setImages:@[[UIImage imageNamed:@"pic_niuniu120"]] forState:MJRefreshStatePulling];
    [header setImages:@[[UIImage imageNamed:@"pic_niuniu120"]] forState:MJRefreshStateRefreshing];
    
    return header;
}

+ (MJRefreshBackGifFooter *)refreshGifFooterWithTarget:(id)target action:(SEL)selector {
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:selector];
    [footer setImages:@[[UIImage imageNamed:@"pic_niuniu120"]] forState:MJRefreshStateIdle];
    [footer setImages:@[[UIImage imageNamed:@"pic_niuniu120"]] forState:MJRefreshStatePulling];
    [footer setImages:@[[UIImage imageNamed:@"pic_niuniu120"]] forState:MJRefreshStateRefreshing];
    
    return footer;
}

+ (MJRefreshNormalHeader *)refreshDefaultHeaderWithTarget:(id)target action:(SEL)selector {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:selector];
    
    return header;
}

+ (MJRefreshBackNormalFooter *)refreshDefaultFooterWithTarget:(id)target action:(SEL)selector {
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:selector];
    
    return footer;
}

@end
