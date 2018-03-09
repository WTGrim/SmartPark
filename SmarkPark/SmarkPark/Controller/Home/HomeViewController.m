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

@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherHeight;
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

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    _scrollView.contentInset = UIEdgeInsetsMake(_weatherHeight.constant, 0, 0, 0);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
