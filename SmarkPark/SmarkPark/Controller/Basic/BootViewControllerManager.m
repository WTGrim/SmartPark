//
//  BootViewControllerManager.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "BootViewControllerManager.h"
#import "HomeViewController.h"
#import "LoginViewController.h"

@implementation BootViewControllerManager

+ (UINavigationController *)initBootController{
    HomeViewController *home = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    return homeNav;
//    LoginViewController *home = [[LoginViewController alloc]init];
//    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:home];
//    return homeNav;
}

@end
