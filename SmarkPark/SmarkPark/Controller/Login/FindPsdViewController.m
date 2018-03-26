//
//  FindPsdViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/12.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindPsdViewController.h"
#import "LeftViewTextField.h"
#import "NetworkTool.h"
#import "BackBtnLayer.h"

static const NSInteger kTotalTimeInterval = 60;

@interface FindPsdViewController ()

@property (weak, nonatomic) IBOutlet LeftViewTextField *phone;
@property (weak, nonatomic) IBOutlet LeftViewTextField *code;
@property (weak, nonatomic) IBOutlet LeftViewTextField *psd;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation FindPsdViewController{
    UIButton *_vertiBtn;
    dispatch_source_t _timer;
    NSInteger _second;
    NSDictionary *_codeDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"重置密码";
    UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    _phone.leftView = phoneImage;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *psdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_psd"]];
    _psd.leftView = psdImage;
    _psd.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *codeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_code"]];
    _code.leftView = codeImage;
    _code.leftViewMode = UITextFieldViewModeAlways;
    
    _vertiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_vertiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vertiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_vertiBtn setTitleColor:ThemeColor_BlackText forState:UIControlStateNormal];
    [_vertiBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    _code.rightView = _vertiBtn;
    _code.rightViewMode = UITextFieldViewModeAlways;
    
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 40)];
    [_submitBtn.layer addSublayer:loginBtnLayer];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
}



- (void)getCode{
    
    if (![CommonTools isTelNumber:_phone.text]) {
        [AlertView showMsg:@"请输入正确的手机号码"];
        return;
    }
    [AlertView showProgress];
    WEAKSELF;
    //获取验证码接口
    [NetworkTool getVerifyCodeWithPhone:_phone.text succeedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        [weakSelf dealTimer:result];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)dealTimer:(NSDictionary *)dict{
    _codeDict = [NSDictionary dictionaryWithDictionary:[dict objectForKey:kData]];
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

- (IBAction)submitBtnClick:(UIButton *)sender {
    
    if (![CommonTools isTelNumber:_phone.text]) {
        [AlertView showMsg:@"请输入正确的手机号码"];
        return;
    }
    NSArray *textFei = @[_code, _psd];
    NSArray *message = @[@"请输入验证码", @"请输入密码"];
    __block BOOL canGo = true;
    __block NSString *msg = nil;
    [textFei enumerateObjectsUsingBlock:^(UITextField  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.text.length == 0) {
            canGo = false;
            msg = message[idx];
            *stop = true;
        }
    }];
    if (!canGo) {
        [AlertView showMsg:msg];
        return;
    }
    
    if (_psd.text.length > 12 || _psd.text.length < 6) {
        [AlertView showMsg:@"请输入6-12位长度的密码"];
        return;
    }
    
    [AlertView showProgress];
    WEAKSELF;
    [NetworkTool forgetPsdWithPhone:_phone.text pwd:_psd.text code:_code.text sign:[_codeDict objectForKey:kSign] exp:[[_codeDict objectForKey:kExp] integerValue] succeedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        [weakSelf presentData:result];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo message]];
    }];
}

- (void)presentData:(NSDictionary *)dict{
    [[UserStatus shareInstance]initWithDict:[dict objectForKey:kData]];
    [AlertView showMsg:@"重置密码成功"];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)backClick{
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
