//
//  MineWalletViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineWalletViewController.h"

@interface MineWalletViewController ()


@property (weak, nonatomic) IBOutlet UILabel *wallet;
@property (weak, nonatomic) IBOutlet UIButton *cashDetailBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;

@end

@implementation MineWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"我的钱包";
    _bgView.backgroundColor = ThemeColor_NavGreen;
    _cashDetailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _cashDetailBtn.layer.borderWidth = 1;
    _cashDetailBtn.layer.masksToBounds = true;
    self.showGreenNav = true;
    
}

#pragma mark - 收支明细
- (IBAction)scoreDetail:(UIButton *)sender {
    
}

#pragma mark - 发布
- (IBAction)pubBtn:(UIButton *)sender {
    
}

@end
