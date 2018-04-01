//
//  MineSettingViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineSettingViewController.h"
#import "BackBtnLayer.h"

@interface MineSettingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *cache;
@property (weak, nonatomic) IBOutlet UIButton *logoffBtn;


@end

@implementation MineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)setupUI{
    self.title = @"设置";
    
    BackBtnLayer *btnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 40)];
    [_logoffBtn.layer addSublayer:btnLayer];
}

- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 100://设置头像
        {
            
        }
            break;
        case 101://设置称呼
        {
            
        }
            break;
        case 102://设置电话
        {
            
        }
            break;
        case 103://清除缓存
        {
            
        }
            break;
        default:
            break;
    }
}


- (IBAction)logoffBtnClick:(UIButton *)sender {
    
}


@end
