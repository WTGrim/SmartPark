//
//  LoginSegment.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/8.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "LoginSegment.h"

#define LoginSegmentTag 100

@implementation LoginSegment{
    UIImageView *_slider;
    UIButton *_currentBtn;
    NSInteger _currentSelectedIndex;
    NSMutableArray*_btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    NSArray *titles = @[@"登录", @"注册"];
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    _btnArray = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(idx * w, 20, w, h)];
        btn.tag = LoginSegmentTag + idx;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:titles[idx] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (idx == 0) {
            [self setSelectedStatus:btn];
            _currentBtn = btn;
            _currentSelectedIndex = idx;
        }else{
            [self setNormalStutas:btn];
        }
        
        [_btnArray addObject:btn];
    }];
    
    _slider = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) /4.0 - 10 , 0, 20, 20)];
    _slider.image = [UIImage imageNamed:@"Share_zone"];
    [self addSubview:_slider];
    
    
}

- (void)btnClick:(UIButton *)btn{
    
    if (_currentBtn == btn) return;
    [self setNormalStutas:_currentBtn];
    [self setSelectedStatus:btn];
    _currentBtn = btn;
    _currentSelectedIndex = btn.tag - LoginSegmentTag;
    [self sliderAnimation:btn];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_currentSelectedIndex == selectedIndex) return;
    [self setNormalStutas:_currentBtn];
    [self setSelectedStatus:(UIButton *)_btnArray[selectedIndex]];
    _currentBtn = _btnArray[selectedIndex];
    [self sliderAnimation:_currentBtn];
}

- (void)sliderAnimation:(UIButton *)btn{
    
    CGFloat w = CGRectGetWidth(self.frame) / 4.0;
    if (btn.tag == LoginSegmentTag) {
        _slider.transform = CGAffineTransformIdentity;
    }else{
        _slider.transform = CGAffineTransformMakeTranslation(w * 3 - 10, 0);
    }
}

- (void)setSelectedStatus:(UIButton *)btn{
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
}

- (void)setNormalStutas:(UIButton *)btn{
    [btn setTitleColor:ThemeColor_GrayText forState:UIControlStateNormal];
}


@end
