//
//  ABSideReresh.h
//  侧滑刷新
//
//  Created by wjy0916 on 17/3/5.
//  Copyright © 2017年 AB.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 刷新状态

 - ABRefreshStatuNormak: 默认状态
 - ABRefreshStatuPulling: 松手就可以刷新的状态
 - ABRefreshStatuRefreshing: 刷新中的状态
 */
typedef NS_ENUM(NSInteger,ABRefreshStatus){

    ABRefreshStatusNormal = 0,
    ABRefreshStatusPulling,
    ABRefreshStatusRefreshing,
};
//刷新Block
typedef void(^refresh)();

@interface ABSideRefresh : UIControl

+(ABSideRefresh *)refreshWihtBlock:(refresh)refreshBlock;

-(void)endRefresh;
-(void)beginRefresh;
-(void)setImages:(NSArray *)images;


@end
