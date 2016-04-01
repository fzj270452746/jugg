//
//  CollectionViewCell.h
//  WaterFlow
//
//  Created by Jacqui on 16/3/22.
//  Copyright © 2016年 Jugg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface CollectionViewCell : UICollectionViewCell
+ (UINib *)nib;

- (void)configureModel:(ShopModel *)model;
@end
