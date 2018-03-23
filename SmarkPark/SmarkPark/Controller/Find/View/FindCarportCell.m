//
//  FindCarportCell.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/15.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindCarportCell.h"

@implementation FindCarportCell{
    
    __weak IBOutlet UILabel *location;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *owner;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    
    location.text = [dict objectForKey:kAddress];
    time.text = [NSString stringWithFormat:@"空闲时间：%@-%@", [dict objectForKey:kStart], [dict objectForKey:kEnd]];
    price.text = [NSString stringWithFormat:@"价格：%.2f积分", [[dict objectForKey:kPrice] floatValue]];
    owner.text = [NSString stringWithFormat:@"由车主 %@ 提供车位", [dict objectForKey:kName]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
