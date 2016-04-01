//
//  ViewController.m
//  WaterFlow
//  
//  Created by Jacqui on 16/3/22.
//  Copyright © 2016年 Jugg. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowLayout.h"
#import "CollectionViewCell.h"
#import "ShopModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>

@interface ViewController () <UICollectionViewDataSource , UICollectionViewDelegate, WaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation ViewController

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)loadDataFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"];
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dic in data) {
        ShopModel *shopModel = [ShopModel new];
        shopModel = [ShopModel mj_objectWithKeyValues:dic];
        [self.datasource addObject:shopModel];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCollectionView];
    [self setupRefreshing];
}

- (void)setupCollectionView
{
    WaterFlowLayout *waterFlow = [[WaterFlowLayout alloc] init];
    waterFlow.waterFlowDelegate = self;
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:waterFlow];
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    self.collectionview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.collectionview];
    
    [self.collectionview registerNib:[CollectionViewCell nib] forCellWithReuseIdentifier:@"Cell"];
}

- (void)setupRefreshing
{
    self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.collectionview.mj_header beginRefreshing];
    
    self.collectionview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionview.mj_footer.hidden = YES;
}

- (void)refreshData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.datasource removeAllObjects];
        [self loadDataFromPlist];
        [self.collectionview reloadData];
        
        [self.collectionview.mj_header endRefreshing];
    });
}

- (void)loadMoreData
{
    self.collectionview.mj_footer.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDataFromPlist];
        [self.collectionview reloadData];
        
        [self.collectionview.mj_footer endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionview.mj_footer.hidden = self.datasource.count == 0;
    return self.datasource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(CollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell configureModel:self.datasource[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
}

#pragma mark - WaterFlowLayoutDelegate
- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
     ShopModel *shopModel = self.datasource[index];
    
    return itemWidth * [shopModel.h floatValue]/[shopModel.w floatValue];
}

- (CGFloat)columnCountInWaterflowLayout:(WaterFlowLayout *)waterflowLayout
{
    return 3;
}

- (CGFloat)columnMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout
{
    return 20;
}

- (CGFloat)rowMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout
{
    return 20;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
@end
