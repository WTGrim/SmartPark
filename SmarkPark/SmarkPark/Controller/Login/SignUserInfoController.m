//
//  SignUserInfoController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "SignUserInfoController.h"
#import "LeftViewTextField.h"
#import "BackBtnLayer.h"

@interface SignUserInfoController ()

@property (weak, nonatomic) IBOutlet LeftViewTextField *name;
@property (weak, nonatomic) IBOutlet LeftViewTextField *phone;
@property (weak, nonatomic) IBOutlet LeftViewTextField *carType;
@property (weak, nonatomic) IBOutlet LeftViewTextField *carNo;

@property (weak, nonatomic) IBOutlet UIButton *sumitBtn;


@end

@implementation SignUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"注册信息";
    
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 40)];
    [_sumitBtn.layer addSublayer:loginBtnLayer];
    
}


- (IBAction)submitClick:(UIButton *)sender {
    
    NSArray *arr = @[_name, _phone];
    NSArray *msg = @[@"请输入称呼", @"请输入手机号"];
     __block NSString *tips = nil;
    __block BOOL canGo = true;
    [arr enumerateObjectsUsingBlock:^(LeftViewTextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.text.length == 0) {
            tips = msg[idx];
            canGo = false;
            *stop = YES;
        }
    }];
    
    if (!canGo) {
        [AlertView showMsg:tips duration:1.5];
        return;
    }
    
    if (![CommonTools isTelNumber:_phone.text]) {
        [AlertView showMsg:@"请输入正确的手机号码" duration:1.5];
        return;
    }
    
    
    
}

@end
