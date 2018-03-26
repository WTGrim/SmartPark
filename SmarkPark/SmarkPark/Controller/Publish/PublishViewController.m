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
#import "NetworkTool.h"
#import "DatePickerView.h"
#import "NSDate+Extension.h"
#import "MinePointAnnotation.h"

@interface PublishViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MAMapViewDelegate, AMapLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *carportType;
@property (weak, nonatomic) IBOutlet UITextField *carOwner;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *plates;
@property (weak, nonatomic) IBOutlet UITextField *carType;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;
@property (weak, nonatomic) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UIView *pickerBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong)NSArray *cartPortArr;
@property (nonatomic, strong)NSArray *carTypeArr;
@property (nonatomic, strong)NSArray *priceArr;

//地图相关
@property(nonatomic, strong)MAMapView *aMapView;
@property(nonatomic, strong)AMapLocationManager *locationManager;

//用户位置标注
@property(nonatomic, strong)MAPinAnnotationView *minePinView;
@property(nonatomic, strong)MinePointAnnotation *minePoint;

@end

@implementation PublishViewController{
    
    NSInteger _carTypeSelectedRow;
    NSInteger _sizeSelectedRow;
    
    NSInteger _selectedRow;
    UITextField *_currentTextField;
    BOOL _isFirstLoad;

    //保存当前位置
    CLLocation *_currentLocation;
    AMapLocationReGeocode *_regecode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self getDataNetwork];
}

- (void)setupUI{
    self.title = @"发布车位";
    
    _isFirstLoad = true;
    _startTime.delegate = self;
    _endTime.delegate = self;
    _price.delegate = self;
    _carportType.delegate = self;
    _carType.delegate = self;
    _startTime.delegate = self;
    _endTime.delegate = self;
    
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
    
    _aMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [_aMapView setNeedsLayout];
    [_mapBgView addSubview:_aMapView];
    _aMapView.distanceFilter = 200;
    _aMapView.headingFilter = 90;
    _aMapView.showsUserLocation = false;
    _aMapView.delegate = self;
    
    //定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)getDataNetwork{
    
    [AlertView showProgress];
    [NetworkTool getLastParkWithSucceedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        if(![result isKindOfClass:[NSNull class]] && ![[result objectForKey:kData] isKindOfClass:[NSNull class]]){
            [self presentData:[result objectForKey:kData]];
        }
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)presentData:(NSDictionary *)dict{
    
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    if (_isFirstLoad) {
        _isFirstLoad = false;
        _minePoint = [[MinePointAnnotation alloc]init];
        _minePoint.coordinate = location.coordinate;
        [_aMapView addAnnotation:_minePoint];
        [_aMapView showAnnotations:@[_minePoint] animated:true];
        [_aMapView setZoomLevel:16 animated:true];
        [self.locationManager stopUpdatingLocation];
        _currentLocation = location;
        _regecode = reGeocode;
        _address.text = _regecode.formattedAddress;
    }
    
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode){
        NSLog(@"reGeocode:%@", reGeocode);
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //用户位置不需要自定义
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MinePointAnnotation class]]) {
        static NSString *pinID = @"minePin";
        MAPinAnnotationView *pinView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
        if (pinView == nil) {
            pinView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pinID];
        }
        pinView.image = [UIImage imageNamed:@"pub_mineLocation"];
        pinView.canShowCallout = false;
        _minePinView = pinView;
        return pinView;
    }
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return _priceArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedRow = row;
    if (_currentTextField == _startTime) {
        _currentTextField = _startTime;
    }else if(_currentTextField == _endTime){
        _currentTextField = _endTime;
        
    }else{
        _currentTextField = _price;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

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
    
    if (textField == _startTime || textField == _endTime) {
        //年-月-日-时-分
        DatePickerView *datepicker = [[DatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            if (textField == _startTime) {
                _startTime.text = dateString;
            }else{
                _endTime.text = dateString;
            }
            NSLog(@"选择的日期：%@",dateString);
        }];
        
        datepicker.dateLabelColor = RGB(65, 188, 241);//年-月-日-时-分 颜色
        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        datepicker.doneButtonColor = RGB(65, 188, 241);//确定按钮的颜色
        [datepicker show];
    }
    if (textField == _startTime) {
        _currentTextField = _startTime;
        [self showPicker];
    }else if(textField == _endTime){
        _currentTextField = _endTime;

    }else if(_currentTextField == _price){
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
        if(_currentTextField == _endTime){
            
        }else if(_currentTextField == _price){
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
    
    [AlertView showProgress];
    NSString *address = [NSString stringWithFormat:@"%@%@", _regecode.street?:@"", _regecode.number?:@""];
    [NetworkTool pubCarportWithName:_carOwner.text phone:_phone.text plates:_plates.text type:_carTypeSelectedRow size:_sizeSelectedRow price:[_price.text floatValue] start:_startTime.text end:_endTime.text province:_regecode.province city:_regecode.city district:_regecode.district address:address latitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude succeedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        [self pubSuccess:[result  objectForKey:kData]];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)pubSuccess:(NSDictionary *)dict{
    
}

#pragma mark - 取消与确认
- (IBAction)pickerEnsureClick:(UIButton *)sender {
    if (!_pickerBackView.hidden) {
        [self dismissPicker];
    }
}

@end
