//
//  LoginView.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/8.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "LoginView.h"
#import "BackBtnLayer.h"
#import <Masonry.h>

@implementation LoginView{
    UITextField *_phone;
    UITextField *_password;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 10;
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    bgView.layer.shadowOpacity = 0.3;
    bgView.layer.masksToBounds = true;
    [self addSubview:bgView];
    
    _phone = [UITextField new];
    _phone.layer.cornerRadius = 3;
    _phone.layer.masksToBounds = true;
    _phone.placeholder = @"手机号登录";
    _phone.backgroundColor = RGB(246, 246, 246);
    UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    _phone.leftView = phoneImage;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:_phone];
    
    _password = [UITextField new];
    _password.placeholder = @"登录密码";
    _password.layer.cornerRadius = 3;
    _password.secureTextEntry = true;
    _password.layer.masksToBounds = true;
    _password.backgroundColor = RGB(246, 246, 246);
    UIImageView *psdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    _password.leftView = psdImage;
    _password.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:_password];
    
    UIButton *seebtn = [UIButton new];
    [seebtn addTarget:self action:@selector(seePsdClick:) forControlEvents:UIControlEventTouchUpInside];
    _password.rightView = seebtn;
    _password.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *loginBtn = [UIButton new];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.shadowColor = RGBA(206, 248, 246, 0.9).CGColor;
    loginBtn.layer.shadowOffset = CGSizeMake(5, 5);
    [bgView addSubview:loginBtn];
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, CGRectGetWidth(loginBtn.frame), CGRectGetHeight(loginBtn.frame))];
    [loginBtn.layer addSublayer:loginBtnLayer];
    
    UIButton *forgetBtn = [UIButton new];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgetBtn];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(20);
        make.top.equalTo(bgView).offset(20);
        make.height.equalTo(@40);
        make.right.equalTo(bgView).offset(-20);
    }];
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_phone);
        make.top.equalTo(_phone).offset(10);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_phone);
        make.top.equalTo(_password).offset(20);
        make.height.equalTo(@50);
    }];
}

#pragma mark - 忘记密码
- (void)forgetBtnClick{
    
}

#pragma mark - 显示密码
- (void)seePsdClick:(UIButton *)btn{
    _password.secureTextEntry = btn.isSelected;
    btn.selected = !btn.selected;
}

@end
