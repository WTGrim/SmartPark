//
//  PublishViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/22.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "PublishViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "BackBtnLayer.h"

@interface PublishViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;
@property (weak, nonatomic) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UIView *pickerBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong)NSArray *timeArr;
@property (nonatomic, strong)NSArray *priceArr;
//地图相关
@property(nonatomic, strong)MAMapView *aMapView;
@property(nonatomic, strong)AMapLocationManager *locationManager;

@end

@implementation PublishViewController{
    NSInteger _selectedRow;
    UITextField *_currentTextField;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"发布车位";
    
    _time.delegate = self;
    _price.delegate = self;
    
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 40)];
    [_pubBtn.layer addSublayer:loginBtnLayer];
    
    _pickerBackView.layer.borderColor = RGBA(150, 150, 150, 1.0).CGColor;
    _pickerBackView.layer.borderWidth = 0.5f;
    _pickerBackView.backgroundColor = [UIColor whiteColor];
    _pickerBackView.hidden = YES;
    _pickerBackView.transform = CGAffineTransformMakeTranslation(0, 185);
    _pickerBgView.hidden = YES;
    
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_currentTextField == _time) {
        return _timeArr.count;
    }
    return _priceArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedRow = row;
    if (_currentTextField == _time) {
        _currentTextField = _time;
    }else{
        _currentTextField = _price;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_currentTextField == _time) {
        return _timeArr[row];
    }
    return _priceArr[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = true;
    }
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _time) {
        _currentTextField = _time;
        [self showPicker];
    }else{
        _currentTextField = _price;
        [self showPicker];
    }
    return false;
}

- (void)showPicker{
    _pickerBackView.hidden = false;
    _pickerBgView.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{
        _pickerBackView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(_currentTextField == _time){
            _time.text = _timeArr[_selectedRow];
        }else{
            _price.text = _priceArr[_selectedRow];
        }
    }];
}

- (void)dismissPicker{
    
    [UIView animateWithDuration:0.25 animations:^{
        _pickerBackView.transform = CGAffineTransformMakeTranslation(0, 185);
    } completion:^(BOOL finished) {
        _pickerBgView.hidden = true;
        _pickerBackView.hidden = true;
    }];
}

#pragma mark - 确认发布
- (IBAction)ensurePubClick:(UIButton *)sender {
    
}

#pragma mark - 取消与确认
- (IBAction)pickerEnsureClick:(UIButton *)sender {
    
}

@end
