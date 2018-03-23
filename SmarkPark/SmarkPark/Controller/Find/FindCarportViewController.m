//
//  FindCarportViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/15.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindCarportViewController.h"
#import "LeftViewTextField.h"
#import "NetworkTool.h"
#import "FindCarportCell.h"
#import "FindCarportHeader.h"
#import "FindCarportDetailController.h"
#import "LocationTool.h"

@interface FindCarportViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)LeftViewTextField *textField;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)FindCarportHeader  *header;

@end

@implementation FindCarportViewController{
    NSInteger _pageIndex;
    NSString *_currentKeyword;
    NSArray *_currentAddress;
    CLLocation *_currentLocation;
    NSInteger _currentType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"找车位";
    _pageIndex = 1;
    
    [self setNavBar];
    [self setTableView];
    [self startLocation];
}

- (void)startLocation{
    
    WEAKSELF;
    [SVProgressHUD show];
    [[LocationTool shareInstance] beginLocation];
    [LocationTool shareInstance].locationCompleted = ^(NSArray *address, CLLocation *location) {
        _currentAddress = address;
        _currentLocation = location;
        _currentKeyword = @"";
        [weakSelf searchCarport];
    };
}

- (void)setTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SAFE_NAV_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 120;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = ThemeColor_BackGround;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindCarportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindCarportCell class])];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self.dataArray removeAllObjects];
        [self searchCarport];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self searchCarport];
    }];
}

#pragma mark - 搜索车位
- (void)searchCarport{
    [SVProgressHUD dismiss];
    [SVProgressHUD show];
    [NetworkTool findCarportWithKeyword:_currentKeyword province:_currentAddress[0] city:_currentAddress[1] district:_currentAddress[2] latitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude index:_pageIndex size:COMMON_PAGE_SIZE type:_currentType succeedBlock:^(NSDictionary * _Nullable result) {
        [SVProgressHUD dismiss];
        [self presentData:[result objectForKey:kData]];
        
    } failedBlock:^(id  _Nullable errorInfo) {
        [SVProgressHUD dismiss];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)presentData:(NSArray *)array{
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];

    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
    
    if (self.dataArray.count < COMMON_PAGE_SIZE && _pageIndex == 1) {
        self.tableView.mj_footer.hidden = true;
    }
    
    if (self.dataArray.count < COMMON_PAGE_SIZE && _pageIndex != 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - header点击事件
- (void)headerClick:(FindCarportHeaderType)type{
    _currentType = type;
    _pageIndex = 1;
    [self.dataArray removeAllObjects];
    [self searchCarport];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindCarportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindCarportCell class]) forIndexPath:indexPath];
    if(self.dataArray.count != 0){
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.tableView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FindCarportDetailController *detail = [[FindCarportDetailController alloc]init];
    detail.dict = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self hiddenKeyboard];
        return YES;
    }
    
    if (textField.text.length != 0) {
        [self searchCarport];
        return YES;
    }
    return YES;
}

- (void)hiddenKeyboard{
    if (_textField.isFirstResponder) {
        [_textField resignFirstResponder];
    }
}

- (void)setNavBar{
    
    _textField = [[LeftViewTextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 30)];
    _textField.backgroundColor = ThemeColor_BackGround;
    _textField.layer.cornerRadius = 15;
    _textField.layer.masksToBounds = true;
    _textField.placeholder = @"搜索车位";
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.textColor = ThemeColor_BlackText;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"find_search"]];
    _textField.leftView = imageView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.delegate = self;
    self.navigationItem.titleView = _textField;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (FindCarportHeader *)header{
    if (!_header) {
        _header = [[FindCarportHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        NSArray *arr = @[@"推荐车位", @"附近车位", @"最快车位"];
        WEAKSELF;
        [_header setTitles:arr didSelected:^(FindCarportHeaderType type) {
            [weakSelf headerClick:type];
        }];
    }
    return _header;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
