//
//  FindPsdViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/12.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindPsdViewController.h"

@interface FindPsdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *_phone;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *psd;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation FindPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"重置密码";
    
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    
}


@end
