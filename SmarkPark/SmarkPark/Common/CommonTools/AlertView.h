//
//  AlertView.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertView : NSObject

+ (void)showMsg:(NSString *)msg duration:(CGFloat)duration;

+ (void)showProgress:(NSString *)msg timeout:(CGFloat)timeout;

+ (void)showError:(NSString *)msg duration:(CGFloat)duration;

+ (void)dimiss;
@end
