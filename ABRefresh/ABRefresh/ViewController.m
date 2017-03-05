//
//  ViewController.m
//  ABRefresh
//
//  Created by wjy0916 on 17/3/5.
//  Copyright © 2017年 AB.ios. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ABSideRefresh.h"

#define RankColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collect;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collect];
}

-(void)refresh{
    NSLog(@"***************************************");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //此处根据实际情况加载
        [self.collect.abRefresh endRefresh];
        [self.collect.abLoadMore endLoadMore];
    });
}

-(UICollectionView *)collect{
    if (!_collect) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.view.bounds.size;
        layout.minimumLineSpacing  = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collect = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collect.dataSource = self;
        _collect.delegate = self;
        _collect.pagingEnabled = YES;
        [_collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collect.abRefresh = [ABSideRefresh refreshWihtBlock:^{
            [self refresh];
        }];
        _collect.abLoadMore = [ABSideLoadMore loadMoreWihtBlock:^{
            [self refresh];
        }];
        
    }
    return _collect;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = RankColor;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
