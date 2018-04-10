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
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *balance;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    
    operation.text = [self getOperationWithType:[[dict objectForKey:kType]integerValue]];
    time.text = [dict objectForKey:kTime];
    balance.text = [NSString stringWithFormat:@"%@", [dict objectForKey:kAmount]];
    if ([[dict objectForKey:kAmount] floatValue] > 0) {
        balance.textColor = ThemeColor_Red;
    }else{
        balance.textColor = ThemeColor_NavGreen;
    }
}

- (NSString *)getOperationWithType:(NSInteger)type{
    NSArray *arr = @[@"用车", @"收入", @"退款", @"充值", @"未知"];
    return arr[type - 1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
