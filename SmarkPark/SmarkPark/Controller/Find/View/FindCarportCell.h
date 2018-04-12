//
//  FindCarportCell.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/15.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CellType) {
    CellType_Find,
    CellType_Record,
};
#import <UIKit/UIKit.h>

@interface FindCarportCell : UITableViewCell

- (void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath type:(CellType)type;

@end
