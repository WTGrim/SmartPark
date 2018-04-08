//
//  UseCameraOrPhoto.m
//  FineexFQXD
//
//  Created by dsperson on 2016/12/13.
//  Copyright © 2016年 FineEx. All rights reserved.
//

#import "UseCameraOrPhoto.h"
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoClipViewController.h"
@interface UseCameraOrPhoto ()
/** <#(id)#> */
@property (strong,nonatomic) UseCamera *camera;
@end
@implementation UseCameraOrPhoto


- (void)useSystemWith:(kUseSystemType)systemType root:(UIViewController *)root block:(kGetUserCameraPhoto)block{
    
    self.camera = [UseCamera new];
    switch (systemType) {
        case kUseSystemTypeCamera:
        {
            self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.camera useSystemCameraWithRoot:root imageBlock:^(UIImage *image,NSString *filePath) {
                if (block) {
                    block(image, filePath);
                }
            }];
        }
            break;
        case kUseSystemTypePhoto:
        {
            self.camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.camera useSystemCameraWithRoot:root imageBlock:^(UIImage *image, NSString *filePath) {
                if (block) {
                    block(image, filePath);
                }
            }];
        }
            break;
        default:
            break;
    }
}
- (void)dealloc
{
    
}


@end


@interface UseCamera()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
PhotoClipDelegate
>
/** <#(id)#> */
@property (strong,nonatomic) UIViewController *root;
/** <#(id)#> */
@property (copy, nonatomic) kGetUserCameraPhoto kGetUserCameraPhoto;
@end

@implementation UseCamera

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)checkAuthorizationStatus_AfteriOS8
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
            //[self requestAuthorizationStatus_AfteriOS8];
            
            return true;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self showAlertWithMessage:@"无权限！请在隐私中开启"];
            //[self showAccessDenied];
            return false;
            
        }
        case PHAuthorizationStatusAuthorized:
            return true;
            
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)useSystemCameraWithRoot:(UIViewController *)root imageBlock:(kGetUserCameraPhoto)imageBlock {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = self.sourceType;
    picker.delegate = self;
    picker.navigationBar.barTintColor = [UIColor colorWithRed:50.0f/255.0f green:51.0f/255.0f blue:52.0f/255.0f alpha:1.0f];
    //picker.navigationBar.barTintColor = [UIColor whiteColor];
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    picker.allowsEditing = YES;
    self.root = root;
    
    self.kGetUserCameraPhoto = imageBlock;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self chargePermtedWithPicker:picker];

    } else {
    }
}


- (BOOL)chargePermtedWithPicker:(UIImagePickerController *)picker {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    __block BOOL type = false;
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self.root.navigationController presentViewController:picker animated:true completion:^{
                        //
                    }];
                }else{
                    
                }
            }];

            // 许可对话没有出现，发起授权许可
            
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //type = [self checkAuthorizationStatus_AfteriOS8];
            // 已经开启授权，可继续
            type = true;
            [self.root.navigationController presentViewController:picker animated:true completion:^{
                
            }];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            type = false;
            // 用户明确地拒绝授权，或者相机设备无法访问
            //            [DSAlertView showMessage:@"无权限！请在隐私中开启"];
            [self showAlertWithMessage:@"无权限！请在隐私中开启"];
            break;
        default:
            break;
    }
    return type;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        PhotoClipViewController *imgCropperVC = [[PhotoClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.root.view.frame.size.width, self.root.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [picker presentViewController:imgCropperVC animated:NO completion:nil];
    }else{
        UIImage *imageEdit =[info objectForKey: UIImagePickerControllerEditedImage];
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        if (image && self.kGetUserCameraPhoto) {
            self.kGetUserCameraPhoto(imageEdit ?:image,info[@"UIImagePickerControllerReferenceURL"]);
        }
        [self.root dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.root dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imageCropper:(PhotoClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    if (editedImage) {
        self.kGetUserCameraPhoto(editedImage, nil);
    }
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [cropperViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [self.root dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(PhotoClipViewController *)cropperViewController {
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [cropperViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [self.root dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)showAlertWithMessage:(NSString *)message{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"现在设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication]openURL:settingUrl];
        }
    }]];
    [self.root presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc
{
    
}
@end

@interface UsePhoto : UseCameraOrPhoto

@end
