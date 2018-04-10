//
//  MineWalletViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineWalletViewController.h"
#import "MineWalletTableViewCell.h"
#import "NetworkTool.h"

@interface MineWalletViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *wallet;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pageIndex;
@end

@implementation MineWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getData];
}

- (void)setupUI{
    
    self.title = @"我的钱包";
    _pageIndex = 1;
    _bgView.backgroundColor = ThemeColor_NavGreen;
    self.showGreenNav = true;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineWalletTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineWalletTableViewCell class])];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 50;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self.dataArray removeAllObjects];
        [self getData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self getData];
    }];
}


- (void)getData{
    
    [NetworkTool getUserWalletWithPageIndex:_pageIndex pageSize:COMMON_PAGE_SIZE SucceedBlock:^(NSDictionary * _Nullable result) {
        [self presentData:[result objectForKey:kData]];
    } failedBlock:^(id  _Nullable errorInfo) {
        _pageIndex--;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)presentData:(NSDictionary *)dict{
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if(_pageIndex == 1 && dict){
        _wallet.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:kIntegral] floatValue]];
    }
    NSArray *arr = [dict objectForKey:@"list"];
    if (arr.count < COMMON_PAGE_SIZE && _pageIndex != 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.dataArray addObjectsFromArray:arr];
    [_tableView reloadData];
    if (arr.count < COMMON_PAGE_SIZE && _pageIndex == 1) {
        _tableView.mj_footer.hidden = true;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineWalletTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _tableView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
