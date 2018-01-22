//
//  CameraViewController.m
//  TravelThroughTime
//
//  Created by logan on 2018/1/15.
//  Copyright © 2018年 gs. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface CameraViewController ()
@property(nonatomic, strong) AVCaptureSession* session;
@property(nonatomic, strong) AVCaptureDeviceInput* captureInput;
@property(nonatomic, strong) AVCaptureStillImageOutput* imageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PermissionUtil sharedInstance] requestAccessForCamera:^(BOOL granted) {
        if (granted) {
            [self initCapture];
            [self.session startRunning];
        }

    }];
}

- (void)setViewFrame:(CGRect)frame{
    self.view.frame = frame;
    self.previewLayer.frame = self.view.bounds;
}
- (void)initCapture {
    //session
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    
    //input
    AVCaptureDevice* device = nil;
    NSArray* cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* camera in cameras) {
        if (camera.position == AVCaptureDevicePositionBack) {
            device = camera;
        }
    }
    NSError* error = nil;
    AVCaptureDeviceInput* input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    self.captureInput = input;
    
    //output
    AVCaptureStillImageOutput* output = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary* setting = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [output setOutputSettings:setting];
    self.imageOutput = output;
    
    //add input and output
    if ([self.session canAddInput:self.captureInput]) {
        [self.session addInput:self.captureInput];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    //create preview layer
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    //self.view.layer.masksToBounds = YES;
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //add layer
    [self.view.layer insertSublayer:self.previewLayer above:self.view.layer];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
