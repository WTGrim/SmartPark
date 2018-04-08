//
//  CommonSystemAlert.h
//  JXBFineEx
//
//  Created by 沙漏 on 2018/1/22.
//  Copyright © 2018年 Fineex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonSystemAlert : NSObject


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle rootVc:(UIViewController *)rootVc leftClick:(void(^)(void))leftClick rightClick:(void(^)(void))rightClick;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style leftStyle:(UIAlertActionStyle)leftStyle rightStyle:(UIAlertActionStyle)rightStyle leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle rootVc:(UIViewController *)rootVc leftClick:(void(^)(void))leftClick rightClick:(void(^)(void))rightClick;

+ (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder style:(UIAlertControllerStyle)style leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle rootVc:(UIViewController *)rootVc leftClick:(void (^)(void))leftClick rightClick:(void (^)(NSString *text))rightClick;

@end
