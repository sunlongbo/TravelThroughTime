//
//  MainViewController.m
//  TravelThroughTime
//
//  Created by logan on 2018/1/15.
//  Copyright © 2018年 gs. All rights reserved.
//

#import "MainViewController.h"
#import "CameraViewController.h"
#import "HistoryPictureViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>
#import "PictureFoldViewController.h"
@interface MainViewController ()
@property (nonatomic, strong) CameraViewController* cameraVC;
@property (nonatomic, strong) HistoryPictureViewController* pictureVC;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.cameraVC = [CameraViewController new];
    self.pictureVC= [HistoryPictureViewController new];
    [self addChildViewController:self.cameraVC];
    [self addChildViewController:self.pictureVC];
    [self.view addSubview:self.cameraVC.view];
    [self.view addSubview:self.pictureVC.view];
    self.pictureVC.view.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"发现目标正在处理"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
//            self.cameraVC.viewFrame = CGRectMake(0, 0, ScreenWith, ScreenHeight);
//            self.pictureVC.view.hidden = NO;
//            self.pictureVC.viewFrame =CGRectMake(0, 0, ScreenWith, ScreenHeight);

            PictureFoldViewController* nextVC = [[PictureFoldViewController alloc]init];
            [self.navigationController pushViewController:nextVC animated:YES];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)startAccelerometerListener{
//    CMMotionManager* manager = [[CMMotionManager alloc]init];
//    self.motionManager = manager;
//    if ([manager isAccelerometerAvailable] ) {
//        manager.accelerometerUpdateInterval = 1;
//        NSOperationQueue* queue = [[NSOperationQueue alloc]init];
//        [manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
//            NSLog(@"X=%.04f",accelerometerData.acceleration.x);
////            NSLog(@"Y=%.04f",accelerometerData.acceleration.y);
////            NSLog(@"Z=%.04f",accelerometerData.acceleration.z);
//        }];
//    }
//}




@end
