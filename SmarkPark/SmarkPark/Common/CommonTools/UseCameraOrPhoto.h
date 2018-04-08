//
//  UseCameraOrPhoto.h
//  FineexFQXD
//
//  Created by dsperson on 2016/12/13.
//  Copyright © 2016年 FineEx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kGetUserCameraPhoto)(UIImage *image, NSString *filePath);
typedef NS_ENUM(NSInteger, kUseSystemType) {
    kUseSystemTypeCamera,
    kUseSystemTypePhoto
};

@interface UseCameraOrPhoto : NSObject
- (void)useSystemWith:(kUseSystemType)systemType root:(UIViewController *)root block:(kGetUserCameraPhoto)block;
@end


@interface UseCamera : UseCameraOrPhoto
/** <#(id)#> */
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
- (void)useSystemCameraWithRoot:(UIViewController *)root imageBlock:(kGetUserCameraPhoto)imageBlock;
@end
