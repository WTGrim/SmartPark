//
//  FindSuccessViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindSuccessViewController.h"
#import "BackBtnLayer.h"

@interface FindSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *successTitle;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@end

@implementation FindSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    NSArray *titles = @[@"停车成功", @"发布成功"];
    self.title = titles[_type];
    
    switch (_type) {
        case SuccessVcType_Find:
        {
            _successTitle.text = @"发布车位成功";
            NSString *price = [NSString stringWithFormat:@"%.2f",  [[_dict objectForKey:kPrice] floatValue]];
            _tips.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"本次发布车位获得%@积分", price] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(8, [price length])];
        }
        case SuccessVcType_Publish:
        {
            _successTitle.text = @"交易完成";
            NSString *price = [NSString stringWithFormat:@"%.2f",  [[_dict objectForKey:kPrice] floatValue]];
            _tips.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"本次停车消费%@积分", price] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(8, [price length])];
        }
            break;  break;
            
        default:
            break;
    }
    
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, 120, 40)];
    [_backBtn.layer addSublayer:loginBtnLayer];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    self.navigationItem.leftBarButtonItem = back;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end
