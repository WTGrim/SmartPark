//
//  MineViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"我的账户";
    _scrollView.delegate = self;
}

#pragma mark - 点击事件
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        _scrollViewHeight.constant = -offsetY;
    }else{
        _scrollViewHeight.constant = 0;
    }
}



@end
