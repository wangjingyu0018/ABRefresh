//
//  UIScrollView+ABSideRefresh.m
//  侧滑刷新
//
//  Created by wjy0916 on 17/3/5.
//  Copyright © 2017年 AB.ios. All rights reserved.
//

#import "UIScrollView+ABSideRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (ABSideRefresh)

#pragma mark - header
static const NSString *ABRefreshHeaderKey = @"refresh";
- (void)setAbRefresh:(ABSideRefresh *)abRefresh{
    
    if (abRefresh != self.abRefresh) {
        // 删除旧的，添加新的
        [self.abRefresh removeFromSuperview];
        //设置刷新动画图片
        [abRefresh setImages:[self animationgImages]];
        [self insertSubview:abRefresh atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"abRefresh"]; // KVO
        objc_setAssociatedObject(self, &ABRefreshHeaderKey,
                                 abRefresh, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"abRefresh"]; // KVO
    }
}

- (ABSideRefresh *)abRefresh
{
    return objc_getAssociatedObject(self, &ABRefreshHeaderKey);
}

#pragma mark - footer
//加载视图Set
static const NSString *ABRefreshFooterKey = @"loadMore";
- (void)setAbLoadMore:(ABSideLoadMore *)abLoadMore{
    if (abLoadMore != self.abLoadMore) {
        // 删除旧的，添加新的
        [self.abLoadMore removeFromSuperview];
        //设置加载动画图片
        [abLoadMore setImages:[self animationgImages]];
        [self insertSubview:abLoadMore atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"abLoadMore"]; // KVO
        objc_setAssociatedObject(self, &ABRefreshFooterKey,
                                 abLoadMore, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"abLoadMore"]; // KVO
    }
}
//加载视图Get
- (ABSideLoadMore *)abLoadMore
{
    return objc_getAssociatedObject(self, &ABRefreshFooterKey);
}

#pragma mark - 加载帧动画图片
-(NSArray *)animationgImages{
    NSMutableArray *tempArrya = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",1000 + i]];
        [tempArrya addObject:image];
    }
    return [tempArrya copy];
}

@end
