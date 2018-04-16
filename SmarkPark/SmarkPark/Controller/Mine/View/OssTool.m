//
//  OssTool.m
//  SmarkPark
//
//  Created by SandClock on 2018/4/16.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "OssTool.h"
#import <AliyunOSSiOS/OSSService.h>

static NSString *const OSSServiceIP = @"http://47.104.6.10:9888";

@implementation OssTool{
    OSSClient * client;
    OSSPutObjectRequest * putRequest;
    NSString * _endPoint;
    NSString * callbackAddress;
    BOOL isCancelled;
    BOOL isResumeUpload;
}

- (instancetype)initWithEndPoint:(NSString *)endPoint{
    if (self = [super init]) {
        _endPoint = endPoint;
        isResumeUpload = false;
        isCancelled = false;
//        [self setKey];
        [self setOSS];
    }
    return self;
}

- (void)setKey{
    OSSCustomSignerCredentialProvider *provider = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        
        // 用户应该在此处将需要签名的字符串发送到自己的业务服务器(AK和SK都在业务服务器保存中,从业务服务器获取签名后的字符串)
        OSSFederationToken *token = [OSSFederationToken new];
        token.tAccessKey = ossAccessKeyId;
        token.tSecretKey = ossAccessKeySecret;
        
        NSString *signedContent = [OSSUtil sign:contentToSign withToken:token];
        return signedContent;
    }];
    
    NSError *error;
    OSSLogDebug(@"%@",[provider sign:@"abc" error:&error]);
}

- (void)setOSS{
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"AccessKeyId" secretKeyId:@"AccessKeySecret" securityToken:@"SecurityToken"];
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]initWithPlainTextAccessKey:ossAccessKeySecret secretKey:ossAccessKeyId];
//    id<OSSCredentialProvider> credential = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:OSSServiceIP];
    client = [[OSSClient alloc] initWithEndpoint:_endPoint credentialProvider:credential];
}

- (void)asynPutImage:(NSString *)objectKey image:(UIImage *)image resultCallBack:(void(^)(BOOL isSuccess))resultCallBack{
    if (image == nil) return;
    putRequest = [OSSPutObjectRequest new];
    putRequest.bucketName = ossBucketName;
    putRequest.objectKey = [NSString stringWithFormat:@"%@%@", ossUrl, objectKey];
    putRequest.uploadingData = UIImageJPEGRepresentation(image, 0.5);
    putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    };
    OSSTask *task = [client putObject:putRequest];
    [AlertView showProgress];
    [task continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        [AlertView dismiss];
        OSSPutObjectResult *result = task.result;
        if (!task.error) {
            
            [self showMsg:@"上传成功"];
            NSLog(@"阿里云回调 : %@", result.serverReturnJsonString);

        }else{
            if (task.error.code == OSSClientErrorCodeTaskCancelled) {
                
                [self showMsg:@"上传取消"];
            }else{
                [self showMsg:@"上传失败"];
            }
        }
        if (resultCallBack) {
            resultCallBack(!task.error);
        }
        putRequest = nil;
        return nil;
        
    }];
}

- (void)showMsg:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AlertView showMsg:msg];
    });
}

- (void)normalRequestCancel {
    if (putRequest) {
        [putRequest cancel];
    }
}
@end
