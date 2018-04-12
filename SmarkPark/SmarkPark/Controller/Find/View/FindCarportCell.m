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
    __weak IBOutlet UILabel *status;
    
    __weak IBOutlet NSLayoutConstraint *topMargin;
    __weak IBOutlet NSLayoutConstraint *statusW;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath type:(CellType)type{
    
    switch (type) {
        case CellType_Find:
        {
            statusW.constant = 0;
            status.hidden = true;
        }
            break;
        case CellType_Record:
        {
            statusW.constant = 44;
            status.hidden = false;
        }
            break;
        default:
            break;
    }
    
    location.text = [dict objectForKey:kAddress];
    NSString *priceTxt = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:kPrice] floatValue]];
    price.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"%@积分", priceTxt] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(0, [priceTxt length])];
    NSString *timeString = [NSString stringWithFormat:@"%@ 至 %@", [dict objectForKey:kStart], [dict objectForKey:kEnd]];
    time.text = timeString;
    NSString *name = StringIsNull([dict objectForKey:kName]) ? @"" : [dict objectForKey:kName];
    owner.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"由车主 %@ 提供车位", name] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(4, [name length])];
    if ([self getHeight:timeString] > 15) {
        topMargin.constant = 20;
    }else{
        topMargin.constant = 5;
    }
    [self setSatatus:1];
    
}

- (void)setSatatus:(NSInteger)statusNum{
    
    switch (statusNum) {
        case 1:
        {
            status.text = @"已完成";
            status.textColor = ThemeColor;
        }
            break;
        case 2:
        {
            status.text = @"已取消";
            status.textColor = ThemeColor_GrayText;
        }
            break;
        case 3:
        {
            status.text = @"用车中";
            status.textColor = ThemeColor_GreenText;
        }
            break;
        default:
            break;
    }
}

- (CGFloat)getHeight:(NSString *)string{
    
    return [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 133, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
