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
#import "OssTool.h"
#import <UIImageView+WebCache.h>

@interface MineSettingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *cache;
@property (weak, nonatomic) IBOutlet UIButton *logoffBtn;
//更换头像的图片
@property (nonatomic, strong)UIImage *iconImage;
@property (nonatomic, strong)UseCameraOrPhoto *cameraOrPhoto;
@property (nonatomic, strong)OssTool *oss;
@property (nonatomic, strong)NSString *imagePath;
@end

@implementation MineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self setOss];
}

#pragma mark - initView
- (void)setupUI{
    self.title = @"设置";
    
    _phone.text = [_dict objectForKey:kPhone];
    if (!StringIsNull([_dict objectForKey:kAvatar])) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:[_dict objectForKey:kAvatar]] placeholderImage:[UIImage imageNamed:@"mine_default"]];
    }else{
        _icon.image = [UIImage imageNamed:@"mine_default"];
    }
    _name.text = !StringIsNull([_dict objectForKey:kName]) ? [_dict objectForKey:kName] : @"";
    
    BackBtnLayer *btnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 40)];
    [_logoffBtn.layer addSublayer:btnLayer];
    
    _cache.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
}

- (void)setOss{
    _oss = [[OssTool alloc]initWithEndPoint:ossEndpoint];
}

#pragma mark - 点击保存
- (void)saveClick{
    [AlertView showProgress];
    WEAKSELF;
    //阿里云上传
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *imageName = [formatter stringFromDate:[NSDate date]];
    [_oss asynPutImage:imageName image:_iconImage resultCallBack:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    }];
}


- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    switch (sender.view.tag) {
        case 100://设置头像
        {
            WEAKSELF;
            [CommonSystemAlert alertWithTitle:@"" message:@"设置头像" style:UIAlertControllerStyleActionSheet leftBtnTitle:@"拍照" rightBtnTitle:@"从相册中选择" rootVc:self leftClick:^{
                [weakSelf.cameraOrPhoto useSystemWith:kUseSystemTypeCamera root:self block:^(UIImage *image,NSString *file) {
                    if (image) {
                        [weakSelf saveImage:image];
                    }
                }];
            } rightClick:^{
                [weakSelf.cameraOrPhoto useSystemWith:kUseSystemTypePhoto root:self block:^(UIImage *image, NSString *file) {
                    if (image) {
                        [weakSelf saveImage:image];
                    }
                }];
            }];
        }
            break;
        case 101://设置称呼
        {
            [CommonSystemAlert textFieldAlertWithTitle:nil message:@"设置称呼" placeholder:@"请输入您的称呼" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:nil rightClick:^(NSString *string) {
                _name.text = string;
            }];
        }
            break;
//        case 102://设置电话
//        {
//            [CommonSystemAlert textFieldAlertWithTitle:nil message:@"设置电话号码" placeholder:@"请输入您的电话号码" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:nil rightClick:^(NSString *text) {
//
//            }];
//        }
//            break;
        default:
            break;
    }
}

#pragma mark - 保存image
- (void)saveImage:(UIImage *)image{
    _iconImage = image;
    _icon.image = _iconImage;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage"];
    [imageData writeToFile:fullPath atomically:false];
    _imagePath = fullPath;
    NSLog(@"%@", _imagePath);
}

#pragma mark - 退出登录
- (IBAction)logoffBtnClick:(UIButton *)sender {
    [CommonSystemAlert alertWithTitle:nil message:@"确定退出登录吗？" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:nil rightClick:^{
        [[UserStatus shareInstance]destoryUserStatus];
        [CommonTools removeLocalWithKey:kSaveUserInfo];
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
