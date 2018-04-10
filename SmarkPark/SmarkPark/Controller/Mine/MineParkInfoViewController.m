//
//  MineParkInfoViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineParkInfoViewController.h"
#import "FindCarportCell.h"
#import "NetworkTool.h"

@interface MineParkInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger pageIndex;

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
    _pageIndex = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SAFE_NAV_HEIGHT) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindCarportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindCarportCell class])];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
    
    WEAKSELF;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf getData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        [weakSelf getData];
    }];
}

- (void)getData{
    
    WEAKSELF;
    [NetworkTool getUserUse_recordWithPageIndex:_pageIndex pageSize:COMMON_PAGE_SIZE SucceedBlock:^(NSDictionary * _Nullable result) {
        
        [weakSelf presentData:[result objectForKey:kData]];
        
    } failedBlock:^(id  _Nullable errorInfo) {
        _pageIndex--;
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
    
    if (arr.count < COMMON_PAGE_SIZE && _pageIndex == 1) {
        _tableView.mj_footer.hidden = true;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindCarportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindCarportCell class]) forIndexPath:indexPath];
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
