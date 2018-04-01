//
//  CarMsgTableViewCell.m
//  SmarkPark
//
//  Created by SandClock on 2018/4/1.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "CarMsgTableViewCell.h"

@implementation CarMsgTableViewCell{
    
    __weak IBOutlet UILabel *carNo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setCellWithDict:(NSString *)car indexPath:(NSIndexPath *)indexPath{
    carNo.text = StringIsNull(car) ? @"" : car;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
