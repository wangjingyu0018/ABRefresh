//
//  UIScrollView+ABSideRefresh.h
//  侧滑刷新
//
//  Created by wjy0916 on 17/3/5.
//  Copyright © 2017年 AB.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSideRefresh.h"
#import "ABSideLoadMore.h"

@interface UIScrollView (ABSideRefresh)

@property (nonatomic, strong) ABSideRefresh *abRefresh;
@property (nonatomic, strong) ABSideLoadMore *abLoadMore;

@end
