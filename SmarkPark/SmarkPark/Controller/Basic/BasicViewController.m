//
//  BasicViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavColor];
    [self setSubView];
    if (!_backItemHidden) {
        [self setBackItem];
    }
}

- (void)setSubView{
    self.view.backgroundColor = ThemeColor_BackGround;
}

- (void)setBackItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStyleDone target:self action:@selector(navigationBackItemClicked)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)navigationBackItemClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNavColor{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBarTintColor:ThemeColor_Nav];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:ThemeColor_Nav];
}

- (void)setNavigationBarShadowHidden {
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:ThemeColor_Nav] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:ThemeColor_Nav]];
}

- (void)setNavigationBarShadowShow {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
