//
//  MinePubInfoViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MinePubInfoViewController.h"
#import "PubListTableViewCell.h"
#import "NetworkTool.h"

@interface MinePubInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger pageIndex;
@end

@implementation MinePubInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getData];
}

- (void)setupUI{
    
    self.title = @"发布车位记录";
    _pageIndex = 1;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SAFE_NAV_HEIGHT) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PubListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PubListTableViewCell class])];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 145;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self.dataArray removeAllObjects];
        [self getData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        [self getData];
    }];
}

- (void)getData{
    
    [NetworkTool getUserPublish_recordWithPageIndex:_pageIndex pageSize:COMMON_PAGE_SIZE SucceedBlock:^(NSDictionary * _Nullable result) {
        [self presentData:[result objectForKey:kData]];
    } failedBlock:^(id  _Nullable errorInfo) {
        _pageIndex --;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)presentData:(NSArray *)arr{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (arr.count < COMMON_PAGE_SIZE && _pageIndex != 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.dataArray addObjectsFromArray:arr];
    [_tableView reloadData];
    
    if (arr.count < COMMON_PAGE_SIZE  && _pageIndex == 1) {
        _tableView.mj_footer.hidden = true;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PubListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PubListTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _tableView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
