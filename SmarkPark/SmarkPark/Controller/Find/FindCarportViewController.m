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

@interface FindCarportViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)LeftViewTextField *textField;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)FindCarportHeader  *header;

@end

@implementation FindCarportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"找车位";
    [self setNavBar];
    [self setTableView];
    
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
}

#pragma mark - 搜索车位
- (void)searchCarport{
    
}

#pragma mark - header点击事件
- (void)headerClick:(FindCarportHeaderType)type{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindCarportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindCarportCell class]) forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
