//
//  HomeViewController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/5.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeWeatherView.h"
#import "LoginViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "CommonSystemAlert.h"

#define HEADER_HEIGHT 136
@interface HomeViewController ()<UIScrollViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherBgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherBgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherWidth;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherText;
@property (weak, nonatomic) IBOutlet UILabel *currentTemper;
@property (weak, nonatomic) IBOutlet UILabel *PM;
@property (weak, nonatomic) IBOutlet UILabel *rightLimit;
@property (weak, nonatomic) IBOutlet UILabel *leftLimit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *weatherTips;
@property (weak, nonatomic) IBOutlet UILabel *humuiTitle;
@property (weak, nonatomic) IBOutlet UILabel *limitTitle;

//定位
@property(nonatomic, strong)AMapLocationManager *locationManager;
//天气
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation HomeViewController{
    CGFloat _originWeatherHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    //检查登录状态
//    if (![UserStatus shareInstance].isLogin) {
//        LoginViewController *login = [[LoginViewController alloc]init];
//        [self presentViewController:login animated:true completion:^{
//
//        }];
//    }
    
    //定位
    [self setAmap];
}


- (void)setAmap{
    
    //没有开启定位服务
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [CommonSystemAlert alertWithTitle:@"温馨提示" message:@"您还没有开启定位服务，现在开启？" style:UIAlertControllerStyleAlert leftBtnTitle:@"取消" rightBtnTitle:@"去开启" rootVc:self leftClick:nil rightClick:^{
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication]openURL:settingUrl];
            }
        }];
        return;
    }
    
    _locationManager = [[AMapLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    [self beginLocation];
}

- (void)beginLocation{
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        NSLog(@"location:%@", location);
        
        if (regeocode){
            NSLog(@"reGeocode:%@", regeocode);
            [self searchLiveWeatherWithCity:regeocode.city];
            
        }
    }];
}

#pragma mark - 搜索天气
- (void)searchLiveWeatherWithCity:(NSString *)city{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city                      = city;
    request.type                      = AMapWeatherTypeLive;
    [self.search AMapWeatherSearch:request];
}

#pragma mark - AMapSearchDelegate
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    if (request.type == AMapWeatherTypeLive){
        if (response.lives.count == 0){
            return;
        }
        
        AMapLocalWeatherLive *liveWeather = [response.lives firstObject];
        if (liveWeather != nil){
            [self setWeatherViewWithWeatrher:liveWeather];
        }
    }
}

- (void)setWeatherViewWithWeatrher:(AMapLocalWeatherLive *)liveWeather{
    
    [self weatherSubViewHidden:false];
    _city.text = liveWeather.city;
    _weatherText.text = liveWeather.weather;
    _currentTemper.text = [NSString stringWithFormat:@"%@ ℃", liveWeather.temperature];
    _PM.text = liveWeather.humidity;
}


- (void)setupUI{
    
    _weatherWidth.constant = SCREEN_WIDTH * 0.8;
    _weatherBgHeight.constant = SCREEN_WIDTH * 0.8;
    _weatherBgWidth.constant = SCREEN_WIDTH;
    _originWeatherHeight = _weatherBgHeight.constant;
    _imageViewHeight.constant = _originWeatherHeight;
    _imageViewWidth.constant = SCREEN_WIDTH;
    _scrollView.contentInset = UIEdgeInsetsMake(_weatherBgHeight.constant, 0, -_weatherBgHeight.constant + 100, 0);
    _scrollView.delegate = self;
    [_weatherView layoutIfNeeded];
    [_weatherView layoutSubviews];
    
    [self weatherSubViewHidden:true];
}

- (void)weatherSubViewHidden:(BOOL)isHidden{
    
    NSArray *arr = @[_weatherImage, _weatherText, _humuiTitle, _PM, _currentTemper, _limitTitle, _rightLimit, _leftLimit];
    [arr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = isHidden;
    }];
    _weatherTips.hidden = !isHidden;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGRect frame = _weatherView.frame;
    _weatherView.backgroundColor = [UIColor redColor];
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    if (offsetY <= 0) {
        frame.origin.y = 0;
        frame.size.height = _originWeatherHeight + -offsetY;
        _imageViewHeight.constant =  _originWeatherHeight + -offsetY;
    }else{
        frame.origin.y = -offsetY;
        frame.size.height = _originWeatherHeight;
        _imageViewHeight.constant = _originWeatherHeight;
    }
    _weatherView.frame = frame;
    [_weatherView layoutIfNeeded];
    [_weatherView layoutSubviews];
    NSLog(@"%.2f", offsetY);
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}

- (void)dealloc{
    _locationManager.delegate = nil;
    _search.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
