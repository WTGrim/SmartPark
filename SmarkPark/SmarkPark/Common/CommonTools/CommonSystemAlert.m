//
//  CommonSystemAlert.m
//  JXBFineEx
//
//  Created by 沙漏 on 2018/1/22.
//  Copyright © 2018年 Fineex. All rights reserved.
//

#import "CommonSystemAlert.h"

@implementation CommonSystemAlert


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle rootVc:(UIViewController *)rootVc leftClick:(void (^)(void))leftClick rightClick:(void (^)(void))rightClick{
    
    [self alertWithTitle:title message:message style:style leftStyle:UIAlertActionStyleDefault rightStyle:UIAlertActionStyleDefault leftBtnTitle:leftBtnTitle rightBtnTitle:rightBtnTitle rootVc:rootVc leftClick:leftClick rightClick:rightClick];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style leftStyle:(UIAlertActionStyle)leftStyle rightStyle:(UIAlertActionStyle)rightStyle leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle rootVc:(UIViewController *)rootVc leftClick:(void (^)(void))leftClick rightClick:(void (^)(void))rightClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:leftBtnTitle style:leftStyle handler:^(UIAlertAction * _Nonnull action) {
        if (leftClick) {
            leftClick();
        }
    }];
    
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:rightBtnTitle style:rightStyle handler:^(UIAlertAction * _Nonnull action) {
        if (rightClick) {
            rightClick();
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:ensure];
    [rootVc presentViewController:alert animated:YES completion:nil];
}

+ (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder style:(UIAlertControllerStyle)style leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle rootVc:(UIViewController *)rootVc leftClick:(void (^)(void))leftClick rightClick:(void (^)(NSString *))rightClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.font = [UIFont systemFontOfSize:13];
        textField.textColor = ThemeColor_BlackText;
        textField.placeholder = placeholder;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:leftBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (leftClick) {
            leftClick();
        }
    }];
    
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:rightBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (rightClick) {
            rightClick(alert.textFields.firstObject.text);
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:ensure];
    [rootVc presentViewController:alert animated:YES completion:nil];
}

@end
