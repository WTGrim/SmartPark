//
//  OssTool.h
//  SmarkPark
//
//  Created by SandClock on 2018/4/16.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OssTool : NSObject

- (instancetype)initWithEndPoint:(NSString *)endPoint;

- (void)asynPutImage:(NSString *)objectKey
               image:(UIImage *)image
      resultCallBack:(void(^)(BOOL isSuccess))resultCallBack;

- (void)normalRequestCancel;

@end
