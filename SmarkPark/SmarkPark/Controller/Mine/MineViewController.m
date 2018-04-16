//
//  MineViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineViewController.h"
#import "MineWalletViewController.h"
#import "MineCarMsgViewController.h"
#import "MineParkInfoViewController.h"
#import "MinePubInfoViewController.h"
#import "MineSettingViewController.h"
#import "MineServiceViewController.h"
#import "CommonSystemAlert.h"
#import "NetworkTool.h"
#import <UIImageView+WebCache.h>

static NSString *const kServiceCall = @"18818181818";

@interface MineViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation MineViewController{
    NSDictionary *_dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getData];
}

- (void)setupUI{
    
    self.title = @"我的账户";
    _scrollView.delegate = self;
}

- (void)getData{
    [NetworkTool getUserInfoWithSucceedBlock:^(NSDictionary * _Nullable result) {
        [self presentData:[result objectForKey:kData]];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)presentData:(NSDictionary *)dict{
    _dict = dict;
    _phone.text = [dict objectForKey:kPhone];
    if (!StringIsNull([dict objectForKey:kAvatar])) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:kAvatar]] placeholderImage:[UIImage imageNamed:@"mine_default"]];
    }else{
        _icon.image = [UIImage imageNamed:@"mine_default"];
    }
    _account.text = !StringIsNull([dict objectForKey:kName]) ? [dict objectForKey:kName] : @"";
    
}

#pragma mark - 点击事件
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
            
        case 100:
        {
            MineWalletViewController *wallet = [[MineWalletViewController alloc]init];
            [self.navigationController pushViewController:wallet animated:true];
        }
            break;
        case 101:
        {
            MineCarMsgViewController *carMsg = [[MineCarMsgViewController alloc]init];
            carMsg.dict = _dict;
            [self.navigationController pushViewController:carMsg animated:true];
        }
            break;
        case 102:
        {
            MineParkInfoViewController *park = [[MineParkInfoViewController alloc]init];
            [self.navigationController pushViewController:park animated:true];
        }
            break;
        case 103:
        {
            MinePubInfoViewController *pub = [[MinePubInfoViewController alloc]init];
            [self.navigationController pushViewController:pub animated:true];
        }
            break;
        case 104:case 99:
        {
            MineSettingViewController *setting = [[MineSettingViewController alloc]init];
            setting.dict = _dict;
            [self.navigationController pushViewController:setting animated:true];
        }
            break;
        case 105:
        {
            [CommonSystemAlert alertWithTitle:@"联系客服" message:kServiceCall style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"确定" rootVc:self leftClick:^{
                
            } rightClick:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",kServiceCall]]];
            }];
//            MineServiceViewController *service = [[MineServiceViewController alloc]init];
//            [self.navigationController pushViewController:service animated:true];
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
