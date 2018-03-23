//
//  AlertView.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "AlertView.h"
#import <MBProgressHUD.h>

@implementation AlertView

+ (void)showMsg:(NSString *)msg icon:(NSString *)icon view:(UIView *)view{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.label.text = msg;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1秒之后再消失
        [hud hideAnimated:true afterDelay:1.5];
    });
}

+ (void)showMsg:(NSString *)msg{
    [self showMsg:msg icon:nil view:nil];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self showMsg:error icon:@"error" view:view];
}

+ (void)showError:(NSString *)error{
    [self showError:error toView:nil];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self showMsg:success icon:@"successhud" view:view];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showProgress:(NSString *)msg timeout:(CGFloat)timeout{
    if (msg) {
        [SVProgressHUD showProgress:timeout status:msg];
    }else{
        [SVProgressHUD showProgress:timeout];
    }
}

+ (void)showError:(NSString *)msg duration:(CGFloat)duration{
    [SVProgressHUD showErrorWithStatus:msg];
    [SVProgressHUD dismissWithDelay:duration];
}

+ (void)dimiss{
    [SVProgressHUD dismiss];
}

@end
