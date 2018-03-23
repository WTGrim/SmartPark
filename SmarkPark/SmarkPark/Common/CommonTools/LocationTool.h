//
//  LocationTool.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/23.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface LocationTool : NSObject

+ (instancetype)shareInstance;
@property(nonatomic, copy)void(^locationCompleted)(NSArray *address, CLLocation *location);

@end
