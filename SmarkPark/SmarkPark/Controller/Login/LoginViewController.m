//
//  LoginViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginSegment.h"

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

@property (nonatomic, strong)LoginSegment *segment;

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
    
    [_segmentView addSubview:self.segment];
    _signScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, <#CGFloat height#>)
    _signScrollView.delegate = self;
    
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

- (LoginSegment *)segment{
    if(!_segment){
        _segment = [[LoginSegment alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_segmentView.frame), CGRectGetHeight(_segmentView.frame))];
    }
    return _segment;
}

@end
