//
//  EnsureReserveController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/16.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "EnsureReserveController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "CommonSystemAlert.h"
#import "MinePointAnnotation.h"
#import "GeocodeAnnotation.h"
#import "BackBtnLayer.h"


@interface EnsureReserveController ()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate, AMapNaviDriveManagerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapBgViewHeight;
@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UILabel *leisureTime;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *cancelTips;
@property (weak, nonatomic) IBOutlet UIButton *ensurePortBtn;

//地图相关
@property(nonatomic, strong)MAMapView *aMapView;
@property(nonatomic, strong)AMapLocationManager *locationManager;
//用户位置标注
@property(nonatomic, strong)MAPinAnnotationView *minePinView;
@property(nonatomic, strong)MinePointAnnotation *minePoint;
@property(nonatomic, strong)AMapSearchAPI *search;
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;


@end

@implementation EnsureReserveController{
    BOOL _isFirstLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupLocation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _aMapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    [_aMapView setNeedsLayout];
}

- (void)setupUI{
    
    _mapBgViewHeight.constant = SCREEN_WIDTH;
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [_ensurePortBtn.layer addSublayer:loginBtnLayer];
    
    [_cancelBtn setBackgroundColor:ThemeColor_RedText];
}

- (void)setupLocation{
    
    _aMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [_aMapView layoutIfNeeded];
    [_mapBgView addSubview:_aMapView];
    _aMapView.distanceFilter = 200;
    _aMapView.headingFilter = 90;
    _aMapView.showsUserLocation = true;
    _aMapView.delegate = self;
    
    //没有开启定位服务
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [CommonSystemAlert alertWithTitle:@"温馨提示" message:@"您还没有开启定位服务，现在开启？" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"去开启" rootVc:self leftClick:nil rightClick:^{
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication]openURL:settingUrl];
            }
        }];
    }
    
    //定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager startUpdatingLocation];
    if ([AMapLocationManager headingAvailable]) {
        [self.locationManager startUpdatingHeading];
    }
    
    //搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = @"四川大学望江校区";
    [self.search AMapGeocodeSearch:geo];
    
    
    //导航
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    
}

#pragma mark - 展示路线方案
- (void)showRouteNavi{
    
    AMapNaviPoint *start = [AMapNaviPoint locationWithLatitude:_startCoordinate.latitude longitude:_startCoordinate.longitude];
    AMapNaviPoint *end = [AMapNaviPoint locationWithLatitude:_destinationCoordinate.latitude longitude:_destinationCoordinate.longitude];
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[start] endPoints:@[end] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyMultipleDefault];
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    NSLog(@"onCalculateRouteSuccess");
    
    //显示路径或开启导航
    NSUInteger count = driveManager.naviRoute.routeCoordinates.count;
    __block CLLocationCoordinate2D *coords = malloc(count * sizeof(CLLocationCoordinate2D));
    [driveManager.naviRoute.routeCoordinates enumerateObjectsUsingBlock:^(AMapNaviPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coords[idx] = CLLocationCoordinate2DMake(obj.latitude, obj.longitude);
    }];
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    [_aMapView removeOverlays:_aMapView.overlays];
    [_aMapView addOverlay:polyline];
    
    NSInteger hour = driveManager.naviRoute.routeTime / 3600;
    NSInteger second = driveManager.naviRoute.routeTime / 60;
    NSString *hourStr = hour > 0? [NSString stringWithFormat:@"%ld小时", (long)hour] : @"";
    NSString *secondStr = second > 0?[NSString stringWithFormat:@"%ld分钟", (long)second] : @"";
//    _planTime.text = [NSString stringWithFormat:@"%@%@",hourStr, secondStr];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error{
    NSLog(@"路线规划失败 %@", error);
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        mapView.visibleMapRect = overlay.boundingMapRect;
        
        MAPolylineRenderer *render = [[MAPolylineRenderer alloc]initWithOverlay:overlay];
        render.lineWidth = 8;
        render.strokeColor = [UIColor greenColor];
        
        return render;
    }
    return nil;
}


#pragma mark - AMapSearchDelegate
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0){
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count == 1){
        [self.aMapView setCenterCoordinate:[(GeocodeAnnotation *)annotations[0] coordinate] animated:YES];
        _destinationCoordinate = [(GeocodeAnnotation *)annotations[0] coordinate];
        //路线规划
        [self showRouteNavi];
    }else{
        [self.aMapView showAnnotations:annotations animated:YES];
        [AlertView showMsg:@"目标停车位地址不够具体明确，存在多个位置" duration:1.5];
    }
    
    [self.aMapView addAnnotations:annotations];
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"搜索停车地点失败:Error: %@", error);
}


#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    if (_isFirstLoad) {
        _isFirstLoad = false;
        _minePoint = [[MinePointAnnotation alloc]init];
        _minePoint.coordinate = location.coordinate;
        _startCoordinate = location.coordinate;
        [_aMapView addAnnotation:_minePoint];
        [_aMapView showAnnotations:@[_minePoint] animated:true];
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
    
    //目的地位置
    static NSString *pinID = @"destination";
    MAPinAnnotationView *pinView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    if (pinView == nil) {
        pinView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pinID];
    }
    pinView.image = [UIImage imageNamed:@"map_carport"];
    pinView.animatesDrop = true;
    pinView.canShowCallout = true;
    return pinView;
}

- (void)dealloc{
    _locationManager.delegate = nil;
    _aMapView.delegate = nil;
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    BOOL success = [AMapNaviDriveManager destroyInstance];
}


#pragma mark - 取消
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
}

#pragma mark - 确认
- (IBAction)ensureBtnClick:(UIButton *)sender {
    
}


@end
