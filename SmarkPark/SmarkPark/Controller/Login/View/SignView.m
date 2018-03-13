//
//  SignView.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/8.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "SignView.h"
#import <Masonry.h>
#import "BackBtnLayer.h"
#import "LeftViewTextField.h"

@implementation SignView{
    LeftViewTextField *_phone;
    LeftViewTextField *_password;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UIView *maskView = [UIView new];
    maskView.layer.shadowColor = RGBA(0, 0, 0, 0.9).CGColor;
    maskView.layer.shadowOpacity = 0.2;
    maskView.layer.shadowRadius = 10;
    maskView.layer.cornerRadius = 10;
    maskView.clipsToBounds = false;
    maskView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:maskView];
    
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = true;
    bgView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:bgView];
    
    _phone = [LeftViewTextField new];
    _phone.placeholder = @"输入手机号";
    _phone.layer.cornerRadius = 3;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.font = [UIFont systemFontOfSize:12];
    _phone.layer.masksToBounds = true;
    _phone.backgroundColor = RGB(246, 246, 246);
    UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    _phone.leftView = phoneImage;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:_phone];
    
    
    _password = [LeftViewTextField new];
    _password.placeholder = @"验证码";
    _password.layer.cornerRadius = 3;
    _password.font = [UIFont systemFontOfSize:12];
    _password.secureTextEntry = true;
    _password.layer.masksToBounds = true;
    _password.backgroundColor = RGB(246, 246, 246);
    UIImageView *psdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_psd"]];
    _password.leftView = psdImage;
    _password.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:_password];
    
    UIButton *seebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [seebtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    seebtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [seebtn setTitleColor:ThemeColor_BlackText forState:UIControlStateNormal];
    [seebtn addTarget:self action:@selector(seePsdClick:) forControlEvents:UIControlEventTouchUpInside];
    _password.rightView = seebtn;
    _password.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *loginBtn = [UIButton new];
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [loginBtn.layer addSublayer:loginBtnLayer];
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = true;
    loginBtn.layer.shadowColor = RGBA(206, 248, 246, 0.9).CGColor;
    loginBtn.layer.shadowOffset = CGSizeMake(5, 5);
    [bgView addSubview:loginBtn];
    
    UIButton *forgetBtn = [UIButton new];
    [forgetBtn setAttributedTitle:[self getAttrString:@"点击注册即表示您同意用户协议"] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn setTitleColor:ThemeColor_GrayText forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(loginProtocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgetBtn];
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(1);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(maskView);
    }];
    
    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(20);
        make.top.equalTo(bgView).offset(30);
        make.height.equalTo(@30);
        make.right.equalTo(bgView).offset(-20);
    }];
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_phone);
        make.top.equalTo(_phone.mas_bottom).offset(10);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_phone);
        make.top.equalTo(_password.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(30);
        make.left.right.equalTo(_password);
        make.height.equalTo(@20);
    }];
}

#pragma mark - 获取验证码
- (void)seePsdClick:(UIButton *)btn{
    if (_signBtnClick) {
        _signBtnClick(SignBtnType_Code);
    }
}

#pragma mark - 注册协议
- (void)loginProtocolBtnClick{
    if (_signBtnClick) {
        _signBtnClick(SignBtnType_Protocol);
    }
}

- (NSAttributedString *)getAttrString:(NSString *)string{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttributes:@{NSForegroundColorAttributeName: ThemeColor_GrayText} range:NSMakeRange(0, string.length - 4)];
    [att addAttributes:@{NSForegroundColorAttributeName: ThemeColor} range:NSMakeRange(string.length - 4, 4)];
    return att;
}

@end
