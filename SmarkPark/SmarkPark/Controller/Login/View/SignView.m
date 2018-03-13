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
#import "NetworkTool.h"

static const NSInteger kTotalTimeInterval = 60;

@implementation SignView{
    LeftViewTextField *_phone;
    LeftViewTextField *_password;
    UIButton *_vertiBtn;
    dispatch_source_t _timer;
    NSInteger _second;
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
    
    _vertiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_vertiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vertiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_vertiBtn setTitleColor:ThemeColor_BlackText forState:UIControlStateNormal];
    [_vertiBtn addTarget:self action:@selector(seePsdClick:) forControlEvents:UIControlEventTouchUpInside];
    _password.rightView = _vertiBtn;
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
    if (![CommonTools isTelNumber:_phone.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    [SVProgressHUD show];
    WEAKSELF;
    //获取验证码接口
    [NetworkTool getVerifyCodeWithPhone:_phone.text succeedBlock:^(NSDictionary * _Nullable result) {
        [weakSelf dealTimer:result];
    } failedBlock:^(id  _Nullable errorInfo) {
        [SVProgressHUD showErrorWithStatus:[errorInfo objectForKey:kMsg]];
        [SVProgressHUD dismissWithDelay:2];
    }];
    
    if (_signBtnClick) {
        _signBtnClick(SignBtnType_Code);
    }
}

- (void)dealTimer:(NSDictionary *)dict{
    [SVProgressHUD dismiss];
    [self startTimer];
}

- (void)startTimer{
    _vertiBtn.enabled = false;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    WEAKSELF;
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf resetTimer];
    });
    dispatch_resume(_timer);
}

- (void)resetTimer{
    _second ++;
    [_vertiBtn setTitle:[NSString stringWithFormat:@"重新获取(%02ld)",(kTotalTimeInterval - _second)] forState:UIControlStateNormal];
    if (_second == kTotalTimeInterval) {
        _second = _second % kTotalTimeInterval;
        dispatch_cancel(_timer);
        [_vertiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _vertiBtn.enabled = true;
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
