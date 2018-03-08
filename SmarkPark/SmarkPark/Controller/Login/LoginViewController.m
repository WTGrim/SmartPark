//
//  LoginViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "LoginViewController.h"

//comfig
#define kHeaderHeight 200
#define kSegmentHeight 50
#define kSignViewHeight 370
#define kMiddleViewHeight 400
#define kBottomHeight 100

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIScrollView *signScrollView;




@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
}



@end
