//
//  MBProgressHUD+Additions.h
//

#import <MBProgressHUD.h>

@interface MBProgressHUD (MT)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showMessageWithOutIcon:(NSString *)message;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


+ (void)showWithRotate:(NSString *)message toView:(UIView *)view;

@end
