//
//  FindCarportHeader.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/15.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "FindCarportHeader.h"

#define FIND_BTN_TAG 100

@interface FindCarportHeader()

@property(nonatomic, copy)void(^didSelected)(FindCarportHeaderType type);

@end

@implementation FindCarportHeader{
    NSArray *_titles;
    NSInteger _currentMethod;
    UIButton *_currentBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setTitles:(NSArray *)titles didSelected:(void (^)(FindCarportHeaderType))didSelected{
    _titles = titles;
    _didSelected = didSelected;
    [self setSubView:titles];
}

- (void)setSubView:(NSArray *)titles{
    
    CGFloat w = CGRectGetWidth(self.frame) / titles.count;
    CGFloat h = CGRectGetHeight(self.frame);
    
    [titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(w * idx, 0, w, h)];
        btn.tag = FIND_BTN_TAG + idx;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (idx == 0) {
            [self setSelected:btn];
            _currentBtn = btn;
        }else{
            [self setNormal:btn];
        }
        [btn setTitle:titles[idx] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
    line.backgroundColor = RGB(216, 216, 216);
    [self addSubview:line];
}

- (void)btnClick:(UIButton *)btn{
    if (_currentBtn == btn) return;
    [self setSelected:btn];
    [self setNormal:_currentBtn];
    _currentBtn = btn;
    if (_didSelected) {
        _didSelected(btn.tag - FIND_BTN_TAG);
    }
}

- (void)setSelected:(UIButton *)btn{
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
}

- (void)setNormal:(UIButton *)btn{
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}
@end
