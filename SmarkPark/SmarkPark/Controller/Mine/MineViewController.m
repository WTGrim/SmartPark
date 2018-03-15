//
//  MineViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"我的账户";
    
}

#pragma mark - 点击事件
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}



@end
