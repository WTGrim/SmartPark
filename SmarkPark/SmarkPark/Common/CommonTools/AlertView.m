//
//  AlertView.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "AlertView.h"


@implementation AlertView

+ (void)showMsg:(NSString *)msg duration:(CGFloat)duration{
    [SVProgressHUD showInfoWithStatus:msg];
    [SVProgressHUD dismissWithDelay:duration];
}

@end
