//
//  OverlayViewController.h
//  meitu
//
//  Created by yiliu on 15/6/15.
//  Copyright (c) 2015年 meitu. All rights reserved.
//

//扫描

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface OverlayViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_captureSession;
    CALayer *_customLayer;
    AVCaptureVideoPreviewLayer *_prevLayer;
}

@property (nonatomic, retain) AVCaptureSession           *captureSession;
@property (nonatomic, retain) CALayer                    *customLayer;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;

@property (nonatomic, retain) UIImage                    *imageJT;          //扫描到的图片
@property (nonatomic, strong) UIImageView                *imageHView;       //扫描线
@property (nonatomic, assign) float                      hightSM;           //扫描线y坐标
@property (nonatomic, strong) NSTimer                    *connectionTimer;  //定时器
@property (nonatomic, assign) BOOL                       isTJ;              //是否正在提交

- (void)initCapture;

@end