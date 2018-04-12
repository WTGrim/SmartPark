//
//  MineSettingViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineSettingViewController.h"
#import "BackBtnLayer.h"
#import "CommonSystemAlert.h"
#import "UseCameraOrPhoto.h"
#import "LoginViewController.h"

@interface MineSettingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *cache;
@property (weak, nonatomic) IBOutlet UIButton *logoffBtn;

@property (nonatomic, strong)UseCameraOrPhoto *cameraOrPhoto;

@end

@implementation MineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)setupUI{
    self.title = @"设置";
    
    BackBtnLayer *btnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 40)];
    [_logoffBtn.layer addSublayer:btnLayer];
    
    _cache.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
}

- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 100://设置头像
        {
            WEAKSELF;
            [CommonSystemAlert alertWithTitle:@"" message:@"设置头像" style:UIAlertControllerStyleActionSheet leftBtnTitle:@"拍照" rightBtnTitle:@"从相册中选择" rootVc:self leftClick:^{
                [weakSelf.cameraOrPhoto useSystemWith:kUseSystemTypeCamera root:self block:^(UIImage *image,NSString *file) {
                    if (image) {
//                        [weakself uploadImage:image];
                    }
                }];
            } rightClick:^{
                [weakSelf.cameraOrPhoto useSystemWith:kUseSystemTypePhoto root:self block:^(UIImage *image, NSString *file) {
                    if (image) {
//                        [weakself uploadImage:image];
                    }
                }];
            }];
        }
            break;
        case 101://设置称呼
        {
            [CommonSystemAlert textFieldAlertWithTitle:nil message:@"设置称呼" placeholder:@"请输入您的称呼" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:nil rightClick:^(NSString *text) {
                
            }];
        }
            break;
        case 102://设置电话
        {
            [CommonSystemAlert textFieldAlertWithTitle:nil message:@"设置电话号码" placeholder:@"请输入您的电话号码" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:nil rightClick:^(NSString *text) {
                
            }];
        }
            break;
        default:
            break;
    }
}


- (IBAction)logoffBtnClick:(UIButton *)sender {
    [CommonSystemAlert alertWithTitle:nil message:@"确定退出登录吗？" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:nil rightClick:^{
        [[UserStatus shareInstance]destoryUserStatus];
        [self presentViewController:[[LoginViewController alloc]init] animated:true completion:nil];
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
}

- (UseCameraOrPhoto *)cameraOrPhoto{
    if (!_cameraOrPhoto) {
        _cameraOrPhoto = [UseCameraOrPhoto new];
    }
    return _cameraOrPhoto;
}


@end
