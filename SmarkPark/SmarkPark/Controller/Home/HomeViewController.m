//
//  HomeViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeWeatherView.h"
#import "LoginViewController.h"

#define HEADER_HEIGHT 136
@interface HomeViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherBgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherBgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherWidth;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherText;
@property (weak, nonatomic) IBOutlet UILabel *currentTemper;
@property (weak, nonatomic) IBOutlet UILabel *dayTemper;
@property (weak, nonatomic) IBOutlet UILabel *PM;
@property (weak, nonatomic) IBOutlet UILabel *rightLimit;
@property (weak, nonatomic) IBOutlet UILabel *leftLimit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HomeViewController{
    CGFloat _originWeatherHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    _weatherWidth.constant = SCREEN_WIDTH * 0.8;
    _weatherBgHeight.constant = SCREEN_WIDTH * 0.8;
    _weatherBgWidth.constant = SCREEN_WIDTH;
    _originWeatherHeight = _weatherBgHeight.constant;
    _imageViewHeight.constant = _originWeatherHeight;
    _imageViewWidth.constant = SCREEN_WIDTH;
    _scrollView.contentInset = UIEdgeInsetsMake(_weatherBgHeight.constant, 0, -_weatherBgHeight.constant + 100, 0);
    _scrollView.delegate = self;
    [_weatherView layoutIfNeeded];
    [_weatherView layoutSubviews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGRect frame = _weatherView.frame;
    _weatherView.backgroundColor = [UIColor redColor];
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    if (offsetY <= 0) {
        frame.origin.y = 0;
        frame.size.height = _originWeatherHeight + -offsetY;
        _imageViewHeight.constant =  _originWeatherHeight + -offsetY;
    }else{
        frame.origin.y = -offsetY;
        frame.size.height = _originWeatherHeight;
        _imageViewHeight.constant = _originWeatherHeight;
    }
    _weatherView.frame = frame;
    [_weatherView layoutIfNeeded];
    [_weatherView layoutSubviews];
    NSLog(@"%.2f", offsetY);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    //检查登录状态
    if (![UserStatus shareInstance].isLogin) {
        LoginViewController *login = [[LoginViewController alloc]init];
        [self presentViewController:login animated:true completion:^{
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
