//
//  WaterFlowLayout.h
//  WaterFlow
//  自定义流布局
//  Created by Jacqui on 16/3/22.
//  Copyright © 2016年 Jugg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>
/**
 * 传递对应的位置，和宽度，返回item的高度
 */
@required
- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**
 *  获取列数
 */
- (CGFloat)columnCountInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;

/**
 *  获取列距
 */
- (CGFloat)columnMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;

/**
 *  获取行距
 */
- (CGFloat)rowMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;

/**
 *  获取边距
 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFlowLayout *)waterflowLayout;
@end

@interface WaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id <WaterFlowLayoutDelegate> waterFlowDelegate;
@end
