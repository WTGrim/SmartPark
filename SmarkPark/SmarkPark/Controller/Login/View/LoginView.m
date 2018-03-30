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
#import "LeftViewTextField.h"
#import "NetworkTool.h"
#import "FindPsdViewController.h"

@implementation LoginView{
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
    _phone.layer.cornerRadius = 3;
    _phone.font = [UIFont systemFontOfSize:12];
    _phone.layer.masksToBounds = true;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.placeholder = @"手机号登录";
    _phone.backgroundColor = RGB(246, 246, 246);
    UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    _phone.leftView = phoneImage;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:_phone];
    
    _password = [LeftViewTextField new];
    _password.placeholder = @"登录密码";
    _password.layer.cornerRadius = 3;
    _password.font = [UIFont systemFontOfSize:12];
    _password.secureTextEntry = true;
    _password.layer.masksToBounds = true;
    _password.backgroundColor = RGB(246, 246, 246);
    UIImageView *psdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_psd"]];
    _password.leftView = psdImage;
    _password.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:_password];
    UIButton *seebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [seebtn setImage:[UIImage imageNamed:@"login_see"] forState:UIControlStateNormal];
    [seebtn addTarget:self action:@selector(seePsdClick:) forControlEvents:UIControlEventTouchUpInside];
    _password.rightView = seebtn;
    _password.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *loginBtn = [UIButton new];
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [loginBtn.layer addSublayer:loginBtnLayer];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = true;
    [loginBtn addTarget:self action:@selector(loginBtnPress) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.shadowColor = RGBA(206, 248, 246, 0.9).CGColor;
    loginBtn.layer.shadowOffset = CGSizeMake(5, 5);
    [bgView addSubview:loginBtn];
    
    UIButton *forgetBtn = [UIButton new];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
        make.height.equalTo(@35);
        make.right.equalTo(bgView).offset(-20);
    }];
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_phone);
        make.top.equalTo(_phone.mas_bottom).offset(20);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_phone);
        make.top.equalTo(_password.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(15);
        make.left.right.equalTo(_password);
        make.height.equalTo(@20);
    }];
    
}

#pragma mark - 忘记密码
- (void)forgetBtnClick{
    
    FindPsdViewController *find = [[FindPsdViewController alloc]init];
    UIViewController *vc = [CommonTools findViewController:self];
    [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:find] animated:true completion:nil];
    
}

#pragma mark - 登录
- (void)loginBtnPress{
    
    if (![CommonTools isTelNumber:_phone.text]) {
        [AlertView showMsg:@"请输入正确的手机号码"];
        return;
    }
    if (_password.text.length == 0) {
        [AlertView showMsg:@"请输入密码"];
        return;
    }
    
    if (_password.text.length < 6 || _password.text.length > 12) {
        [AlertView showMsg:@"请输入6-12位长度的密码"];
        return;
    }
    WEAKSELF;
    [AlertView showProgress];
    [NetworkTool loginWithPhone:_phone.text pwd:_password.text succeedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        [weakSelf loginSucceed:result];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
    if (_loginBtnClick) {
        _loginBtnClick(LoginBtnType_Login);
    }
}

- (void)loginSucceed:(NSDictionary *)dict{
    [[UserStatus shareInstance]initWithDict:[dict objectForKey:kData]];
    [self saveUserInfoWith:[dict objectForKey:kData]];
    [AlertView showMsg:@"登录成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [CommonTools findViewController:self];
        [vc dismissViewControllerAnimated:true completion:nil];
    });
}

- (void)saveUserInfoWith:(NSDictionary *)result {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    for (NSString *key in result.allKeys) {
        if ([result objectForKey:key] != nil && ![[result objectForKey:key] isKindOfClass:[NSNull class]]) {
            [userInfo setObject:[result objectForKey:key] forKey:key];
        }
    }
    [CommonTools saveLocalWithKey:kSaveUserInfo Obj:userInfo];
}

#pragma mark - 显示密码
- (void)seePsdClick:(UIButton *)btn{
    _password.secureTextEntry = btn.isSelected;
    btn.selected = !btn.selected;
}

- (void)hiddenKeyboard{
    if (_phone.isFirstResponder) {
        [_phone resignFirstResponder];
    }
    if (_password.isFirstResponder) {
        [_password resignFirstResponder];
    }
}

@end
