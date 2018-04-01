//
//  MinePubInfoViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MinePubInfoViewController.h"
#import "PubListTableViewCell.h"

@interface MinePubInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MinePubInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getData];
}

- (void)getData{
    
}

- (void)setupUI{
    
    self.title = @"发布车位记录";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SAFE_NAV_HEIGHT) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PubListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PubListTableViewCell class])];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 200;
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PubListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PubListTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
