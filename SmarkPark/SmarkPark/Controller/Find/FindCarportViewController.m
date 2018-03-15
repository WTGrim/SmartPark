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

@interface FindCarportViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)LeftViewTextField *textField;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindCarportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindCarportCell class])];
    [self.view addSubview:_tableView];
}

#pragma mark - 搜索车位
- (void)searchCarport{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindCarportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindCarportCell class]) forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
