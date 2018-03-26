//
//  FindSuccessViewController.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/26.
//  Copyright © 2018年 SmartPark. All rights reserved.
//


typedef NS_ENUM(NSUInteger, SuccessVcType) {
    SuccessVcType_Find = 0,
    SuccessVcType_Publish,
};

#import "BasicViewController.h"

@interface FindSuccessViewController : BasicViewController

@property(nonatomic, assign)SuccessVcType type;


@end
