//
//  PubListTableViewCell.m
//  SmarkPark
//
//  Created by SandClock on 2018/4/1.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "PubListTableViewCell.h"

@implementation PubListTableViewCell{
    
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *carportType;
    __weak IBOutlet UILabel *carType;
    __weak IBOutlet UILabel *carNo;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
