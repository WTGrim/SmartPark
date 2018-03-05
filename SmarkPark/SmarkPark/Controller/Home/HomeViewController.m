//
//  HomeViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeWeatherView.h"

#define HEADER_HEIGHT 136
@interface HomeViewController ()<UIScrollViewDelegate>

//scrollView
@property(nonatomic, strong)UIScrollView *scrollView;
//header
@property(nonatomic, strong)HomeWeatherView *weatherHeader;
//navigationBar‘s alpha
@property(nonatomic, assign) CGFloat navAlpha;
//topView
@property(nonatomic, strong)UIView *topView;
//topContentInset
@property (nonatomic, assign) CGFloat topContentInset;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    
}

- (void)setupUI{
    
    self.title = @"智慧停车";
    _topContentInset = HEADER_HEIGHT;

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -SAFE_NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.5);
    [self.view addSubview:_scrollView];
    [self.view insertSubview:self.weatherHeader belowSubview:_scrollView];
    _scrollView.contentInset = UIEdgeInsetsMake(_topContentInset, 0, 0, 0);
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_topContentInset, 0, 0, 0);
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_navAlpha];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    if (_navAlpha == 0) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_navAlpha < 1) {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_navAlpha];
        [UIView animateWithDuration:0.15 animations:^{
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        }];
    }
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//
//    if ([_scrollView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_scrollView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;//注意
    //    NSLog(@"%lf", offsetY);
    
    if (offsetY > _topContentInset && offsetY <= _topContentInset * 2) {
        
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        _navAlpha = offsetY / (_topContentInset * 2) >= 1 ? 1 : offsetY / (_topContentInset * 2);
        
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_navAlpha];
        
    }else if (offsetY <= _topContentInset) {
        
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _navAlpha = 0;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        
    }else if (offsetY > _topContentInset * 2) {
        _navAlpha = 1;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    }
    CGRect frame = self.weatherHeader.frame;
    if (offsetY < 0) {
        frame.origin.y = -SAFE_NAV_HEIGHT;
        frame.size.height = -offsetY;
    }else{
        frame.origin.y = -offsetY;
        frame.size.height = HEADER_HEIGHT;
    }
    self.weatherHeader.frame = frame;
}

#pragma mark - lazy
- (HomeWeatherView *)weatherHeader{
    if (!_weatherHeader) {
        _weatherHeader = [[HomeWeatherView alloc]initWithFrame:CGRectMake(0, -SAFE_NAV_HEIGHT , SCREEN_WIDTH, HEADER_HEIGHT)];
        _weatherHeader.backgroundColor = [UIColor greenColor];
    }
    return _weatherHeader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
