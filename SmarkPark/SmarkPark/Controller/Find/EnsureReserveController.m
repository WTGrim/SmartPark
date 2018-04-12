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
#import "EnsureCancelController.h"
#import "FindSuccessViewController.h"
#import "NetworkTool.h"

@interface EnsureReserveController ()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate, AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *leisureTime;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *carportType;

@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *cancelTips;
@property (weak, nonatomic) IBOutlet UIButton *ensurePortBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeight;

//地图相关
@property(nonatomic, strong)MAMapView *aMapView;
@property(nonatomic, strong)AMapLocationManager *locationManager;
//用户位置标注
@property(nonatomic, strong)MAPinAnnotationView *minePinView;
@property(nonatomic, strong)MinePointAnnotation *minePoint;
@property(nonatomic, strong)AMapSearchAPI *search;
//导航
@property(nonatomic, strong)AMapNaviDriveView *driveView;
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@end

@implementation EnsureReserveController{
    BOOL _isFirstLoad;
    NSDateFormatter *_dateFormatter;
    dispatch_source_t _timer;
    dispatch_source_t _cancelTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupLocation];
    [self initDriveView];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_mapBgView addSubview:_aMapView];
}

#pragma mark - UI
- (void)setupUI{
    
    self.title = @"预定信息";
    _isFirstLoad = true;
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)];
    [_ensurePortBtn.layer addSublayer:loginBtnLayer];
    
    [_cancelBtn setBackgroundColor:ThemeColor_Red];
    
    _dateFormatter = [[NSDateFormatter alloc]init];
    _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
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
}

- (void)initDriveView{
    if (self.driveView == nil){
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
    }
}

#pragma mark - 获取数据
- (void)getData{
    
    [AlertView showProgress];
    [NetworkTool getParkingInfoWithId:_reserveId SucceedBlock:^(NSDictionary * _Nullable result) {
        [AlertView dismiss];
        [self presentData:[result objectForKey:kData]];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView dismiss];
        [AlertView showMsg:[errorInfo objectForKey:kMessage]];
    }];
}

- (void)presentData:(NSDictionary *)dict{
    
    [self searchDestination:dict];
    _address.text = [dict objectForKey:kAddress];
    _leisureTime.text = [NSString stringWithFormat:@"%@-%@", [dict objectForKey:kStart], [dict objectForKey:kEnd]];
    NSString *priceString = [NSString stringWithFormat:@"%.0f", [[dict objectForKey:kPrice] floatValue]];
    _price.attributedText = [CommonTools createAttributedStringWithString:[NSString stringWithFormat:@"%@积分", priceString] attr:@{NSForegroundColorAttributeName:ThemeColor_Red} rang:NSMakeRange(0, [priceString length])];
    _carportType.text = [CommonTools getCarPortWithType:CarType_CarPortType number:[[dict objectForKey:kType] integerValue]];
    _carType.text = [CommonTools getCarPortWithType:CarType_CarType number:[[dict objectForKey:kSize] integerValue]];
    _carNo.text = [dict objectForKey:kPlates];
    _name.text = [dict objectForKey:kName];
    _phone.text = [dict objectForKey:kPhone];
    
    //UI界面调整
    CGFloat height = 0;
    if ([CommonTools getVerticalHeight:_address.text limitWidth:SCREEN_WIDTH - 112] > 20) {
        height += 20;
    }
    if ([CommonTools getVerticalHeight:_leisureTime.text limitWidth:SCREEN_WIDTH - 112] > 20) {
        height += 20;
    }
    _infoHeight.constant += height;
    NSString *revertTime = [dict objectForKey:kRevert];
    __block NSInteger revert = [revertTime integerValue] / 1000;
    if (revert > 0) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            NSArray *timeArr;
            timeArr = [CommonTools caculateTimeWithInterval:revert];
            if ([timeArr[2] intValue] <= 0 && [timeArr[1] intValue] <= 0 && [timeArr[0] intValue] <= 0) {
                _hour.text = @"--";
                _minute.text = @"--";
                _second.text = @"--";
                dispatch_source_cancel(_timer);
            }else{
                _hour.text = [NSString stringWithFormat:@"%02d", [timeArr[0] intValue]];
                _minute.text = [NSString stringWithFormat:@"%02d", [timeArr[1] intValue]];
                _second.text = [NSString stringWithFormat:@"%02d", [timeArr[2] intValue]];
                revert-- ;
            }
        });
        dispatch_resume(_timer);
        
    }else{
        _hour.text = @"--";
        _minute.text = @"--";
        _second.text = @"--";
    }

    
    //可取消
    NSString *cancelTime = [dict objectForKey:kCancel];
    __block NSInteger cancel = [cancelTime integerValue] / 1000;
    if (cancel > 0) {
        _cancelTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_cancelTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_cancelTimer, ^{
            NSArray *timeArr;
            timeArr = [CommonTools caculateTimeWithInterval:cancel];
            if ([timeArr[2] intValue] <= 0 && [timeArr[1] intValue] <= 0 && [timeArr[0] intValue] <= 0) {
                [_cancelBtn setBackgroundColor:ThemeColor_GrayBtn];
                _cancelBtn.enabled = false;
                _cancelTips.text = @"超过可取消时间，预订车位已不能取消";
                dispatch_source_cancel(_cancelTimer);
            }else{
                _cancelBtn.enabled = true;
                _cancelTips.text = [NSString stringWithFormat:@"距离可取消还剩：%d小时%d分%d秒", [timeArr[0] intValue], [timeArr[1] intValue], [timeArr[2] intValue]];
                cancel--;
            }
        });
        dispatch_resume(_cancelTimer);
    }else{
        [_cancelBtn setBackgroundColor:ThemeColor_GrayBtn];
        _cancelBtn.enabled = false;
        _cancelTips.text = @"超过可取消时间，预订车位已不能取消";
    }

}

#pragma mark - 搜索终点
- (void)searchDestination:(NSDictionary *)dict{
    //搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = [dict objectForKey:kAddress];
    [self.search AMapGeocodeSearch:geo];
    
    //导航
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
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
    
    
    //显示导航按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(beginNaviDrive)];
}

#pragma mark - 开始导航
- (void)beginNaviDrive{
    //算路成功后开始GPS导航
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
    [AMapNaviDriveManager sharedInstance].isUseInternalTTS = true;
    [self.view addSubview:self.driveView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消导航" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNaviDrive)];

}

#pragma mark - 取消导航
- (void)cancelNaviDrive{
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [AMapNaviDriveManager sharedInstance].isUseInternalTTS = false;
    [self.driveView removeFromSuperview];
    //显示导航按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(beginNaviDrive)];
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
    
    [self.locationManager stopUpdatingLocation];
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
        [_locationManager stopUpdatingLocation];
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
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    BOOL success = [AMapNaviDriveManager destroyInstance];
}

/**
 * @brief 导航界面关闭按钮点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    [self.driveView removeFromSuperview];
}

#pragma mark - 取消
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    EnsureCancelController *cancel = [[EnsureCancelController alloc]init];
    [self.navigationController pushViewController:cancel animated:true];
}

#pragma mark - 确认
- (IBAction)ensureBtnClick:(UIButton *)sender {
    FindSuccessViewController *successVc = [[FindSuccessViewController alloc]init];
    successVc.type = SuccessVcType_Find;
    [self.navigationController pushViewController:successVc animated:true];
}


@end
