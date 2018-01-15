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
@interface MainViewController ()
@property (nonatomic, strong)CameraViewController* cameraVC;
@property (nonatomic, strong)HistoryPictureViewController* pictureVC;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraVC = [CameraViewController new];
    self.pictureVC= [HistoryPictureViewController new];
    [self addChildViewController:self.cameraVC];
    [self addChildViewController:self.pictureVC];
}
-(void)viewWillAppear:(BOOL)animated{
    [[PermissionUtil sharedInstance]requestAccessForCamera:^(BOOL granted) {
        if (granted) {
            [self.view addSubview:self.cameraVC.view];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
