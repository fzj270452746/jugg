//
//  CollectionViewCell.m
//  WaterFlow
//
//  Created by Jacqui on 16/3/22.
//  Copyright © 2016年 Jugg. All rights reserved.
//

#import "CollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface CollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *showImgae;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end

@implementation CollectionViewCell
+ (UINib *)nib;
{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)configureModel:(ShopModel *)model
{
    [self.showImgae sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.priceLbl.text = model.price;
}
@end
