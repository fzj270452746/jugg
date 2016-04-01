//
//  WaterFlowLayout.m
//  WaterFlow
//
//  Created by Jacqui on 16/3/22.
//  Copyright © 2016年 Jugg. All rights reserved.
//

#import "WaterFlowLayout.h"

//默认列数
static const NSInteger  FFDefaultColumnCount = 2;
//默认行距
static const CGFloat    FFDefaultRowMargin = 10;
//默认列距
static const CGFloat    FFDefaultColumnMargin = 10;
//默认边缘距离
static const UIEdgeInsets FFDefaultEdgeInsets = {10,10,10,10};

@interface WaterFlowLayout ()
@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic, strong) NSMutableArray *columnHeight;
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) CGFloat contentSizeHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation WaterFlowLayout
#pragma mark - getter
- (CGFloat)rowMargin
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.waterFlowDelegate rowMarginInWaterflowLayout:self];
    } else
        return FFDefaultRowMargin;
}

- (CGFloat)columnMargin
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.waterFlowDelegate columnMarginInWaterflowLayout:self];
    } else
        return FFDefaultColumnMargin;
}

- (NSInteger)columnCount
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.waterFlowDelegate columnCountInWaterflowLayout:self];
    } else
        return FFDefaultColumnCount;
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.waterFlowDelegate edgeInsetsInWaterflowLayout:self];
    } else
        return FFDefaultEdgeInsets;
}

- (NSMutableArray *)attributesArray
{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

- (NSMutableArray *)columnHeight
{
    if (!_columnHeight) {
        _columnHeight = [NSMutableArray array];
    }
    return _columnHeight;
}

#pragma mark - setup
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置列距
    self.minimumInteritemSpacing = self.columnMargin;
    //设置行距
    self.minimumLineSpacing = self.rowMargin;
    self.sectionInset = self.edgeInsets;
    
    if (self.columnCount == 1) {
        self.itemWidth = (self.collectionView.frame.size.width-self.sectionInset.left - self.sectionInset.right)/self.columnCount;
    } else {
        self.itemWidth = (self.collectionView.frame.size.width-self.sectionInset.left - self.sectionInset.right - (self.columnCount-1)*self.minimumInteritemSpacing )/self.columnCount;
    }
    
    ///此处将数组清空为了防止collectionView reloadData时，重新执行该方法，之前数组有历史数据
    [self.columnHeight removeAllObjects];
    [self.attributesArray removeAllObjects];
    //此处重置高度的目的，是防止当加载更多数据后，重新刷新页面数据时，contentSizeHeight扔为加载更多情况下的高度
    self.contentSizeHeight = 0;
    
    //根据列数为数组添加对应的元素
    for (NSInteger i=0; i<self.columnCount; i++) {
        [self.columnHeight addObject:@(self.sectionInset.top)];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [self.attributesArray addObject:att];
    }
}

/**
 *设置UICollectionViewLayoutAttributes的属性，frame
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *atts = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    /**First step:
     * 获取item的高度，通过代理方法根据实际返回的数据来确定当前item的高度
     */
    CGFloat itemHeight = [self.waterFlowDelegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:self.itemWidth];
    
    /**Second step
     * 获取item的对应坐标点
     */
    NSInteger index = 0;
    //设置最小列高
    CGFloat minColumnHeight = [self.columnHeight[index] floatValue];
    if (self.columnHeight.count == 1) {
        if (minColumnHeight != self.sectionInset.top) {
            minColumnHeight += self.minimumLineSpacing;
        }
        atts.frame = CGRectMake(self.sectionInset.left, minColumnHeight, self.itemWidth, itemHeight);
        self.columnHeight[0] = @(CGRectGetMaxY(atts.frame));
        
        self.contentSizeHeight = [self.columnHeight[0] floatValue];
    } else {
        for (NSInteger i=0; i<self.columnCount; i++) {
            if ([self.columnHeight[i] floatValue] < minColumnHeight) {
                index = i;
                minColumnHeight = [self.columnHeight[i] floatValue];
            }
        }
        
        
        
        CGFloat x = self.sectionInset.left + index * (self.minimumInteritemSpacing + self.itemWidth);
        CGFloat y = minColumnHeight;
        if (y != self.sectionInset.top) {
            y += self.minimumLineSpacing;
        }
        atts.frame = CGRectMake(x, y, self.itemWidth, itemHeight);
        self.columnHeight[index] = @(CGRectGetMaxY(atts.frame));
        
        CGFloat curColumnHeight = [self.columnHeight[index] floatValue];
        if (self.contentSizeHeight < curColumnHeight) {
            self.contentSizeHeight = curColumnHeight;
        }
    }
    
    return atts;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentSizeHeight + self.sectionInset.bottom);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}
@end
