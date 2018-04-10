//
//  PubListTableViewCell.m
//  SmarkPark
//
//  Created by SandClock on 2018/4/1.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "PubListTableViewCell.h"

@implementation PubListTableViewCell{
    
    __weak IBOutlet UILabel *address;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *carportType;
    __weak IBOutlet UILabel *carType;
    __weak IBOutlet UILabel *carNo;
    __weak IBOutlet NSLayoutConstraint *priceTop;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    
    address.text = [dict objectForKey:kAddress];
    time.text = [NSString stringWithFormat:@"%@-%@", [dict objectForKey:kStart], [dict objectForKey:kEnd]];
    NSString *priceString = [NSString stringWithFormat:@"%@", [dict objectForKey:kPrice]];
    price.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"%@积分", priceString] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(0, [priceString length])];
    carportType.text = [CommonTools getCarPortWithType:CarType_CarPortType number:[[dict objectForKey:kType]integerValue]];
    carType.text = [CommonTools getCarPortWithType:CarType_CarType number:[[dict objectForKey:kSize]integerValue]];
    carNo.text = [dict objectForKey:kPlates];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
