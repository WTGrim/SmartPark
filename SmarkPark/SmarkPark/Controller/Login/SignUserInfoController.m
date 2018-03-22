//
//  SignUserInfoController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/14.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "SignUserInfoController.h"
#import "LeftViewTextField.h"
#import "BackBtnLayer.h"
#import "NetworkTool.h"

@interface SignUserInfoController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet LeftViewTextField *name;
@property (weak, nonatomic) IBOutlet LeftViewTextField *phone;
@property (weak, nonatomic) IBOutlet LeftViewTextField *carType;
@property (weak, nonatomic) IBOutlet LeftViewTextField *carNo;
@property (weak, nonatomic) IBOutlet UIButton *sumitBtn;
@property (weak, nonatomic) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UIView *pickerBackView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property(nonatomic, strong)NSArray *typeArr;


@end

@implementation SignUserInfoController{
    NSInteger _selectedRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"完善信息";
    BackBtnLayer *loginBtnLayer = [BackBtnLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 40)];
    [_sumitBtn.layer addSublayer:loginBtnLayer];
    
    _carType.delegate = self;
    _phone.enabled = false;
    _phone.text = _phoneNo;
    
    _pickerBackView.layer.borderColor = RGBA(150, 150, 150, 1.0).CGColor;
    _pickerBackView.layer.borderWidth = 0.5f;
    _pickerBackView.backgroundColor = [UIColor whiteColor];
    _pickerBackView.hidden = YES;
    _pickerBackView.transform = CGAffineTransformMakeTranslation(0, 185);
    _pickerBgView.hidden = YES;
    
    _sureBtn.layer.cornerRadius = 3;
    
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    _typeArr = @[@"小型车", @"中型车", @"大型车"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _typeArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedRow = row;
    _carType.text = _typeArr[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _typeArr[row];
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
    if (textField == _carType) {
        _carType.text = nil;
        [self hiddenKeyboard];
        [self downListClick];
        return false;
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hiddenKeyboard];
    return true;
}

- (void)downListClick{
    if (_pickerBackView.hidden) {
        [self showPicker];
    }
}

- (void)showPicker{
    _pickerBackView.hidden = false;
    _pickerBgView.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{
        _pickerBackView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _carType.text = _typeArr[_selectedRow];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenKeyboard];

    if (!_pickerBackView.hidden) {
        [self dismissPicker];
    }
}

- (void)hiddenKeyboard{
    if (_name.isFirstResponder) {
        [_name resignFirstResponder];
    }
    if (_carNo.isFirstResponder) {
        [_carNo resignFirstResponder];
    }
}

- (IBAction)submitClick:(UIButton *)sender {
        
    NSArray *arr = @[_name, _phone];
    NSArray *msg = @[@"请输入称呼", @"请输入手机号"];
     __block NSString *tips = nil;
    __block BOOL canGo = true;
    [arr enumerateObjectsUsingBlock:^(LeftViewTextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.text.length == 0) {
            tips = msg[idx];
            canGo = false;
            *stop = YES;
        }
    }];
    
    if (!canGo) {
        [AlertView showMsg:tips duration:1.5];
        return;
    }
    
    if (![CommonTools isTelNumber:_phone.text]) {
        [AlertView showMsg:@"请输入正确的手机号码" duration:1.5];
        return;
    }
    
    [NetworkTool consummateWithName:_name.text plates:_carNo.text type:_selectedRow + 1 succeedBlock:^(NSDictionary * _Nullable result) {
        [self presentData:result];
    } failedBlock:^(id  _Nullable errorInfo) {
        [AlertView showMsg:[errorInfo objectForKey:kMessage] duration:2];
    }];
}

- (void)presentData:(NSDictionary *)dict{
    
    [self dismissViewControllerAnimated:true completion:^{
        if (_consummateCallBack) {
            _consummateCallBack();
        }
    }];
}


#pragma mark - 取消
- (IBAction)cancelBtn:(UIButton *)sender {
    [self hiddenKeyboard];
    
    if (!_pickerBackView.hidden) {
        [self dismissPicker];
    }
}

- (IBAction)ensureBtn:(UIButton *)sender {
    [self hiddenKeyboard];
    if (!_pickerBackView.hidden) {
        [self dismissPicker];
    }
}


@end
