//
//  FindCarportHeader.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/15.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FindCarportHeaderType) {
    FindCarportHeaderType_default = 0,
    FindCarportHeaderType_local,
    FindCarportHeaderType_fastest,
};

@interface FindCarportHeader : UIView

- (void)setTitles:(NSArray *)titles didSelected:(void(^)(FindCarportHeaderType type))didSelected;


@end
