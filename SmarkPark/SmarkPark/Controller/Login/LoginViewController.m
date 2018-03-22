//
//  LoginViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginSegment.h"
#import "LoginView.h"
#import "SignView.h"

//comfig
#define kHeaderHeight 200
#define kSegmentHeight 50
#define kSignViewHeight 400
#define kMiddleViewHeight 400
#define kBottomHeight 100

@interface LoginViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIScrollView *signScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (nonatomic, strong)LoginSegment *segment;
@property (nonatomic, strong)LoginView *loginView;
@property (nonatomic, strong)SignView *signView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _headerHeight.constant = SCREEN_WIDTH * 0.6;
    _backScrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [_segmentView addSubview:self.segment];
    _signScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    _signScrollView.delegate = self;
    _signScrollView.bounces = false;
    
    [_signScrollView addSubview:self.loginView];
    [_signScrollView addSubview:self.signView];
}

#pragma mark - 三方登录
- (IBAction)trilateralLoginClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 201://QQ登录
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _signScrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        self.segment.selectedIndex = index;
    }
}

#pragma mark - 注册界面点击事件
- (void)signClick:(SignBtnType)type{

}

- (void)loginClick:(LoginBtnType)type{

}

- (LoginSegment *)segment{
    if(!_segment){
        _segment = [[LoginSegment alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_segmentView.frame))];
        WEAKSELF;
        _segment.selectedCallBack = ^(NSInteger selectedIndex) {
            [weakSelf.signScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * selectedIndex, 0) animated:true];
        };
    }
    return _segment;
}

- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_signScrollView.frame))];
        WEAKSELF;
        _loginView.loginBtnClick = ^(LoginBtnType type) {
            [weakSelf loginClick:type];
        };
    }
    return _loginView;
}

- (SignView *)signView{
    if (!_signView) {
        _signView = [[SignView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_signScrollView.frame))];
        WEAKSELF;
        _signView.signBtnClick = ^(SignBtnType type) {
            [weakSelf signClick:type];
        };
    }
    return _signView;
}

@end
