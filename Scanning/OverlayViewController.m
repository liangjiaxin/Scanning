//
//  OverlayViewController.m
//  meitu
//
//  Created by yiliu on 15/6/15.
//  Copyright (c) 2015年 meitu. All rights reserved.
//

#import "OverlayViewController.h"

#define DHLGD 64
#define VIEWWIDTH [[UIScreen mainScreen] bounds].size.width
#define VIEWHIGHT ([[UIScreen mainScreen] bounds].size.height-DHLGD)

@interface OverlayViewController ()

@end

@implementation OverlayViewController

- (id)init {
    self = [super init];
    if (self) {
        self.prevLayer = nil;
        self.customLayer = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCapture];
}

- (void)initCapture {
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    [self.captureSession startRunning];
    self.customLayer = [CALayer layer];
    self.customLayer.frame = self.view.bounds;
    self.customLayer.transform = CATransform3DRotate(
                                                     CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:self.customLayer];
    self.prevLayer = [AVCaptureVideoPreviewLayer
                      layerWithSession: self.captureSession];
    self.prevLayer.frame = CGRectMake(0, DHLGD, VIEWWIDTH, VIEWHIGHT);
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.prevLayer];
    
    UIImageView *imgaView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWWIDTH/2-154, VIEWHIGHT/2-154+DHLGD, 308, 308)];
    imgaView.image = [UIImage imageNamed:@"smk"];
    [self.view addSubview:imgaView];
    
    _imageHView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWWIDTH/2-125, VIEWHIGHT/2-125+DHLGD, 250, 5)];
    _imageHView.image = [UIImage imageNamed:@"qr_scan_line"];
    [self.view addSubview:_imageHView];
    
    [self zhezhao];
    
    _hightSM = VIEWHIGHT/2-125+DHLGD;
    
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
}

//设置半透明遮罩
- (void)zhezhao{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, DHLGD, VIEWWIDTH, VIEWHIGHT/2-125)];
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, DHLGD+VIEWHIGHT/2-125, VIEWWIDTH/2-125, 250)];
    view2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(VIEWWIDTH/2+125, DHLGD+VIEWHIGHT/2-125, VIEWWIDTH/2-125, 250)];
    view3.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    [self.view addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, DHLGD+VIEWHIGHT/2+125, VIEWWIDTH, VIEWHIGHT/2-125)];
    view4.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    [self.view addSubview:view4];
}

//定时器
-(void)timerFired:(NSTimer *)timer{
    if(_hightSM > (VIEWHIGHT/2-125+DHLGD+240)){
        _hightSM = VIEWHIGHT/2-125+DHLGD;
        if(!_isTJ){
            
            float biliX = _imageJT.size.width / 320;
            
            UIImageView *tupView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageJT.size.width, _imageJT.size.height)];
            tupView.image = _imageJT;
            
            CGRect rect = CGRectMake((_imageJT.size.width-250*biliX)/2, (_imageJT.size.height-250*biliX)/2, 250*biliX, 250*biliX);
            
            UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DHLGD, 150, 150)];
            imaView.image = [self captureView:tupView frame:rect];
            [self.view addSubview:imaView];
            
        }
    }else{
        _hightSM = _hightSM + 10;
    }
    _imageHView.frame = CGRectMake(self.view.bounds.size.width/2-125, _hightSM, 250, 5);
}

//
-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
}

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,
                                                    width, height, 8, bytesPerRow, colorSpace,
                                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    _imageJT = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    
    CGImageRelease(newImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0); 
    
} 

#pragma mark - 
#pragma mark Memory management
- (void)viewDidUnload {
    self.customLayer = nil; 
    self.prevLayer = nil; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
