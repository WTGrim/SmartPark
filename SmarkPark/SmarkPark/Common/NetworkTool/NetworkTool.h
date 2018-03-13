//
//  NetworkTool.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/13.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonNetwork.h"

@interface NetworkTool : NSObject

+ (NSURLSessionDataTask *)getVerifyCodeWithPhone:(NSString *)phone succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

@end
