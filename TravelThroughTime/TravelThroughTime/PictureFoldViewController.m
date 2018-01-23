//
//  PictureFoldViewController.m
//  TravelThroughTime
//
//  Created by logan on 2018/1/22.
//  Copyright © 2018年 gs. All rights reserved.
//

#import "PictureFoldViewController.h"

@interface PictureFoldViewController ()
@property (nonatomic, strong) UISlider *slider;
@end

@implementation PictureFoldViewController{
    MultiFoldView *leftFoldView;
    MultiFoldView *curFoldView;
    MultiFoldView *rightFoldView;
    
    CGFloat curOffset;
    BOOL isCompareFlag;
    // 滑动手势
    CGFloat previousTranslation;
    CGFloat totalTranlation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self paperInit];
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(50, ScreenHeight-100, ScreenWith-100, 50)];
    [self.view addSubview:self.slider];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 5;
    self.slider.value = 0;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}



- (void)paperInit
{
    totalNum = 6;
 
    imgArr = [NSMutableArray array];
    foldViewArr = [NSMutableArray array];
    
    for (NSInteger i=0; i<totalNum; ++i)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)i]];
        
        MultiFoldView *foldView = [[MultiFoldView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight) folds:3 pullFactor:0.9];
        foldView.delegate = self;
        [foldView setContent:imageView];
        [self.view addSubview:foldView];
        
        if (i == 0) {
            curOffset = ScreenWith;
            [foldView unfoldViewToFraction:1];
            //            [foldView unfoldWithoutAnimation];
        }else{
            [foldView setHidden:YES];
        }
        [foldViewArr addObject:foldView];
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comparePictures)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

}
- (void)sliderValueChanged:(UISlider *)sender
{
    totalTranlation = sender.value * ScreenWith;
    [self scrollWithValue:sender.value];
}
- (void)scrollWithValue:(CGFloat)value
{
    curIndex = value;
    
    for (MultiFoldView *foldView in foldViewArr) {
        [foldView setHidden:YES];
    }
    
    curOffset = value - curIndex;
    curOffset = (1-curOffset)*ScreenWith;
    
    curFoldView = foldViewArr[curIndex];
    curFoldView.hidden = NO;
    
    [curFoldView setTransform: CGAffineTransformIdentity];
    [curFoldView unfoldWithParentOffset:curOffset];
    
    if (curIndex < 5) {
        NSInteger nextIndex = curIndex + 1;
        
        rightFoldView = foldViewArr[nextIndex];
        
        rightFoldView.hidden = NO;
        
        [rightFoldView unfoldWithoutAnimation];
        [rightFoldView setTransform: CGAffineTransformMakeTranslation(curOffset, 0)];
    }
}
- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            // 结束当前动画
            previousTranslation = [panGesture translationInView:self.view].x;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            // 滑动到最近的页面
            break;
        }
        default:
        {
            // 拖拽
            CGFloat translation = [panGesture translationInView:self.view].x;
            CGFloat diff = previousTranslation - translation;
            
            totalTranlation += diff*1.5;
            
            if (totalTranlation < 0) {
                totalTranlation = 0;
            }else if (totalTranlation > ScreenWith*(totalNum-1)){
                totalTranlation = ScreenWith*(totalNum-1);
            }
            
            previousTranslation = translation;
            
            [self scrollWithValue:totalTranlation/ScreenWith];
        }
    }
}
- (void)comparePictures
{
    // 展开当前的两张图片       暂时取上一张图片的底部 和 下一张图片的顶部
    if (curFoldView==nil || rightFoldView==nil) {
        return;
    }
    
    if (isCompareFlag) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            [self scrollWithValue:totalTranlation/ScreenWith];
        } completion:^(BOOL finished) {
        }];
        
    }else{
        [curFoldView unfoldWithoutAnimation];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [curFoldView setTransform: CGAffineTransformMakeTranslation(0, -ScreenHeight/2)];
            [rightFoldView setTransform: CGAffineTransformMakeTranslation(0, ScreenHeight/2)];
            
        } completion:^(BOOL finished) {
        }];
    }
    isCompareFlag = !isCompareFlag;
}
- (CGFloat)displacementOfMultiFoldView:(id)multiFoldView
{
    CGFloat res;
    res = -curOffset;
    return res;
}
@end
