//
//  PhotoClipViewController.h
//  FineexFQXD2.0
//
//  Created by Dwt on 2018/1/8.
//  Copyright © 2018年 FineEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoClipViewController;

@protocol PhotoClipDelegate <NSObject>

- (void)imageCropper:(PhotoClipViewController *)clipViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(PhotoClipViewController *)clipViewController;

@end

@interface PhotoClipViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<PhotoClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
