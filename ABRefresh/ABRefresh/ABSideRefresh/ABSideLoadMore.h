//
//  ABSideLoadMore.h
//  侧滑刷新
//
//  Created by wjy0916 on 17/3/5.
//  Copyright © 2017年 AB.ios. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 加载状态
 
 - ABLoadMoreStatusNormal: 默认状态
 - ABLoadMoreStatusPulling: 松手就可以刷新的状态
 - ABLoadMoreStatusLoading: 刷新中的状态
 */
typedef NS_ENUM(NSInteger,ABLoadMoreStatus){
    
    ABLoadMoreStatusNormal = 0,
    ABLoadMoreStatusPulling,
    ABLoadMoreStatusLoading,
};

//加载Block
typedef void(^loadMore)();

@interface ABSideLoadMore : UIControl

+(ABSideLoadMore *)loadMoreWihtBlock:(loadMore)loadMoreBlock;

-(void)beginLoadMore;
-(void)endLoadMore;

-(void)setImages:(NSArray *)images;

@end
