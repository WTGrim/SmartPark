//
//  BootViewControllerManager.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "BootViewControllerManager.h"
#import "HomeViewController.h"

@implementation BootViewControllerManager

+ (UINavigationController *)initBootController{
    HomeViewController *home = [[HomeViewController alloc]init];
    home.title = @"智慧停车";
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    return homeNav;
}

@end
