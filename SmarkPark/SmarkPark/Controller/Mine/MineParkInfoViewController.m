//
//  MineParkInfoViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineParkInfoViewController.h"
#import "FindCarportCell.h"

@interface MineParkInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MineParkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getData];
}

- (void)setupUI{
    
    self.title = @"停车记录";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SAFE_NAV_HEIGHT) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindCarportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindCarportCell class])];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
    
}

- (void)getData{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindCarportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindCarportCell class]) forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
