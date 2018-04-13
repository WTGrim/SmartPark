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
#import <AMapSearchKit/AMapSearchKit.h>
#import "GeocodeAnnotation.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "CommonSystemAlert.h"
#import "EnsureReserveController.h"
#import "NetworkTool.h"

@interface FindCarportDetailController ()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate, AMapNaviDriveManagerDelegate>

//地图
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *address;

//空闲时间
@property (weak, nonatomic) IBOutlet UILabel *leisureTime;
@property (weak, nonatomic) IBOutlet UILabel *price;
//预计到达时间
@property (weak, nonatomic) IBOutlet UILabel *planTime;
//确认预定
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leisureTimeTop;

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

@implementation FindCarportDetailController{
    BOOL _isFirstLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setData];
    [self setupLocation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setupUI{
    
    self.title = @"车位预定";
    _isFirstLoad = true;
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [_sureBtn.layer addSublayer:loginBtnLayer];
}

- (void)setData{
    
    NSString *timeString = [NSString stringWithFormat:@"%@ 至 %@", [_dict objectForKey:kStart], [_dict objectForKey:kEnd]];
    _leisureTime.text = timeString;
    NSString *priceString = [NSString stringWithFormat:@"%.0f", [[_dict objectForKey:kPrice] floatValue]];
    _price.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"%@积分", priceString] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(0, [priceString length])];
    if ([CommonTools getVerticalHeight:timeString limitWidth:SCREEN_WIDTH - 108] > 18) {
        _priceTop.constant = 24;
        _bgViewHeight.constant += 15;
    }else{
        _priceTop.constant = 8;
    }
    
    NSString *addressString = [_dict objectForKey:kAddress];
    _address.text = addressString;
    if ([CommonTools getVerticalHeight:addressString limitWidth:SCREEN_WIDTH - 108] > 18) {
        _leisureTimeTop.constant = 24;
        _bgViewHeight.constant += 15;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_mapView addSubview:_aMapView];
}

- (void)setupLocation{
    
    _aMapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _aMapView.distanceFilter = 200;
    _aMapView.headingFilter = 90;
    _aMapView.showsUserLocation = false;
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
    
    //搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = [_dict objectForKey:kAddress];
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
    NSInteger minute = driveManager.naviRoute.routeTime / 60  % 60;
    NSString *hourStr = hour > 0 ? [NSString stringWithFormat:@"%ld小时", (long)hour] : @"";
    NSString *minuteStr = minute > 0 ? [NSString stringWithFormat:@"%ld分钟", (long)minute] : @"";
    NSString *secondStr = hour <= 0 && minute <= 0 ? @"接近目的地" : @"";
    _planTime.text = [NSString stringWithFormat:@"%@%@%@",hourStr, minuteStr, secondStr];
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
        [AlertView showMsg:@"目标停车位地址不够具体明确，存在多个位置"];
    }
    
    [self.aMapView addAnnotations:annotations];
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    [AlertView showMsg:@"搜索停车地点失败"];
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
    if (reGeocode){
        [self.locationManager stopUpdatingLocation];
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

#pragma mark - 确认预定
- (IBAction)sureBtnClick:(UIButton *)sender {
    //查看是否有未完成的订单
    [AlertView showProgress];
    [NetworkTool getParkingStatusWithSucceedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        [self presentData:[result objectForKey:kData]];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

#pragma mark - 预定接口
- (void)presentData:(NSDictionary *)dict{
    
    if ([[dict objectForKey:kId] integerValue] == 0) {
        [AlertView showProgress];
        [NetworkTool getParkingReservationWithId:[[_dict objectForKey:kId] integerValue] SucceedBlock:^(NSDictionary * _Nullable result) {
            [AlertView dismiss];
            [self cheakDetail:[result objectForKey:kData]];
        } failedBlock:^(id  _Nullable errorInfo) {
            [AlertView dismiss];
            [AlertView showMsg:[errorInfo objectForKey:kMessage]];
        }];
        
    }else{
        [AlertView showMsg:@"您还有未完成的订单，请在“停车记录”查看"];
    }
}

- (void)cheakDetail:(NSDictionary *)dict{
    EnsureReserveController *ensure = [[EnsureReserveController alloc]init];
    ensure.reserveId = [[dict objectForKey:kId] integerValue];
    ensure.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:ensure animated:true];
}

- (void)dealloc{
    _locationManager.delegate = nil;
    _aMapView.delegate = nil;
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    BOOL success = [AMapNaviDriveManager destroyInstance];
}


@end
