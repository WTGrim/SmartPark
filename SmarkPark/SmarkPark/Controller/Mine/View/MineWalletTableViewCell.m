//
//  MineWalletTableViewCell.m
//  SmarkPark
//
//  Created by SandClock on 2018/4/4.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineWalletTableViewCell.h"

@implementation MineWalletTableViewCell{
    
    __weak IBOutlet UILabel *operation;
    __weak IBOutlet UILabel *remain;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *balance;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
