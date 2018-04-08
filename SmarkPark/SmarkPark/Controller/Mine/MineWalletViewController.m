//
//  MineWalletViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineWalletViewController.h"
#import "MineWalletTableViewCell.h"

@interface MineWalletViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *wallet;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MineWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"我的钱包";
    _bgView.backgroundColor = ThemeColor_NavGreen;
    self.showGreenNav = true;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineWalletTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineWalletTableViewCell class])];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineWalletTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - 收支明细
- (IBAction)scoreDetail:(UIButton *)sender {
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
