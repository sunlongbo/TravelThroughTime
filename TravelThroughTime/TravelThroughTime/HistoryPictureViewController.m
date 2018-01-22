//
//  HistoryPictureViewController.m
//  TravelThroughTime
//
//  Created by logan on 2018/1/15.
//  Copyright © 2018年 gs. All rights reserved.
//

#import "HistoryPictureViewController.h"
#import "iCarousel.h"
#import <math.h>
@interface HistoryPictureViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, assign) float lastYaw;

@end

@implementation HistoryPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCarouselView];
    self.view.backgroundColor = [UIColor clearColor];
    _lastYaw = 10;

}
- (void)startDeviceMotion {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 3.0;
    self.motionManager.gyroUpdateInterval = 1.0f / 3;
    self.motionManager.showsDeviceMovementDisplay = YES;
    NSOperationQueue* motionQueue = [[NSOperationQueue alloc] init];
    //[self.motionManager setDeviceMotionUpdateInterval:1.0f / 30];
    [self.motionManager startDeviceMotionUpdatesToQueue:motionQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        CMAttitude* attitude = motion.attitude;
        [self scrollItemByYaw:attitude.yaw];
        
    }];
}
- (void)scrollItemByYaw:(float)yaw{
    if (_lastYaw> 2*M_PI) {
        _lastYaw = yaw;
        return;
    }
    if (fabs(yaw-_lastYaw)>M_PI/12) {
        int countPerRad = _items.count/(2*M_PI);
        [self.carousel scrollToItemAtIndex:50+yaw*countPerRad animated:YES];
        _lastYaw = yaw;
    }

    
}
- (void)initCarouselView{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        [_items addObject:@(i)];
    }
    self.carousel = [[iCarousel alloc]initWithFrame:self.view.bounds];
    self.carousel.type = iCarouselTypeTimeMachine;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.carousel];
    [self.carousel reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setViewFrame:(CGRect)viewFrame{
    self.view.frame = viewFrame;
    self.carousel.frame = self.view.frame;
    [self.carousel reloadData];
    [self.carousel scrollToItemAtIndex:50 duration:5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startDeviceMotion];
    });
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        NSString *str = [NSString stringWithFormat:@"%ld.jpg",(long)index];
        ((UIImageView *)view).image = [UIImage imageNamed:str];
        view.contentMode = UIViewContentModeScaleAspectFit;
        
        //        label = [[UILabel alloc] initWithFrame:view.bounds];
        //        label.backgroundColor = [UIColor clearColor];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.font = [label.font fontWithSize:50];
        //        label.tag = 1;
        //        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        //        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [_items[index] stringValue];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}
@end
