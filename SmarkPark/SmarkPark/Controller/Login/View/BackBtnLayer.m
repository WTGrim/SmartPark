//
//  BackBtnLayer.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/8.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "BackBtnLayer.h"

@implementation BackBtnLayer

+ (instancetype)layerWithFrame:(CGRect)frame{
    
    BackBtnLayer *layer = [BackBtnLayer layer];
    layer.frame = frame;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.colors = @[(__bridge id)RGB(56, 212, 214).CGColor, (__bridge id)RGB(107, 219, 235).CGColor];
    return layer;
}

@end
