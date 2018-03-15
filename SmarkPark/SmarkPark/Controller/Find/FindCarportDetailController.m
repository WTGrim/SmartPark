//
//  FindCarportDetailController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/15.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindCarportDetailController.h"
#import "BackBtnLayer.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "MinePointAnnotation.h"

@interface FindCarportDetailController ()<AMapLocationManagerDelegate, MAMapViewDelegate>

//地图
@property (weak, nonatomic) IBOutlet UIView *mapView;
//高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeight;
//空闲时间
@property (weak, nonatomic) IBOutlet UILabel *leisureTime;
//预计到达时间
@property (weak, nonatomic) IBOutlet UILabel *planTime;
//确认预定
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
//用户位置标注
@property(nonatomic, strong)MAPinAnnotationView *minePinView;
@property(nonatomic, strong)MinePointAnnotation *minePoint;

//地图相关
@property(nonatomic, strong)MAMapView *aMapView;
@property(nonatomic, strong)AMapLocationManager *locationManager;

@end

@implementation FindCarportDetailController{
    BOOL _isFirstLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupLocation];
}

- (void)setupUI{
    
    self.title = @"车位信息";
    _isFirstLoad = true;
    _mapViewHeight.constant = SCREEN_WIDTH;
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [_sureBtn.layer addSublayer:loginBtnLayer];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _aMapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    [_aMapView setNeedsLayout];
}

- (void)setupLocation{
    
    _aMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [_mapView layoutIfNeeded];
    [_aMapView layoutIfNeeded];
    [_mapView addSubview:_aMapView];
    _aMapView.distanceFilter = 200;
    _aMapView.headingFilter = 90;
    _aMapView.showsUserLocation = true;
    _aMapView.delegate = self;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager startUpdatingLocation];
    if ([AMapLocationManager headingAvailable]) {
        [self.locationManager startUpdatingHeading];
    }
}


#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    if (_isFirstLoad) {
        _isFirstLoad = false;
        _minePoint = [[MinePointAnnotation alloc]init];
        _minePoint.coordinate = _aMapView.centerCoordinate;
        _minePoint.lockedScreenPoint = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5);
        [_aMapView addAnnotation:_minePoint];
        [_aMapView showAnnotations:@[_minePoint] animated:true];
        [_aMapView setCenterCoordinate:location.coordinate animated:true];
    }
    
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode){
        NSLog(@"reGeocode:%@", reGeocode);
    }
}

//自定义大头针
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
        pinView.image = [UIImage imageNamed:@"map_userLocation"];
        pinView.canShowCallout = false;
        _minePinView = pinView;
        return pinView;
    }
    return nil;
}

#pragma mark - 确认预定
- (IBAction)sureBtnClick:(UIButton *)sender {
    
    
}

- (void)dealloc{
    _locationManager.delegate = nil;
    _aMapView.delegate = nil;
}

@end
