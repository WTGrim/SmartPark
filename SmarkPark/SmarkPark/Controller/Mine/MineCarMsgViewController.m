//
//  MineCarMsgViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineCarMsgViewController.h"
#import "BackBtnLayer.h"

@interface MineCarMsgViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation MineCarMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"车辆信息";
    BackBtnLayer *btnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [_addBtn.layer addSublayer:btnLayer];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView deq]
}



@end
