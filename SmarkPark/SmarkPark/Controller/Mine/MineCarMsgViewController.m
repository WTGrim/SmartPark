//
//  MineCarMsgViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "MineCarMsgViewController.h"
#import "BackBtnLayer.h"
#import "CarMsgTableViewCell.h"

@interface MineCarMsgViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MineCarMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getData];
}

- (void)setupUI{
    
    self.title = @"车辆信息";
    BackBtnLayer *btnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 40)];
    [_addBtn.layer addSublayer:btnLayer];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - SAFE_NAV_HEIGHT - 50);
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CarMsgTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CarMsgTableViewCell class])];
    _tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)getData{
    
    NSMutableArray *arr = [NSMutableArray array];
    if (_dict) {
        NSString *carMsg = [_dict objectForKey:kPlates];
        [arr addObject:carMsg];
    }
    [self.dataArray addObjectsFromArray:arr];
    [_tableView reloadData];
}


#pragma mark - 新增车辆
- (IBAction)addBtnClick:(UIButton *)sender {
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CarMsgTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
        [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //删除请求
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}



- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
