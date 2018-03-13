//
//  NetworkTool.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/13.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "NetworkTool.h"
#import "JSONKit.h"

@implementation NetworkTool

+ (NSURLSessionDataTask *)getVerifyCodeWithPhone:(NSString *)phone succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:kPhone];
    NSString *url = [NSString stringWithFormat:@"%@/sms/get",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

@end
