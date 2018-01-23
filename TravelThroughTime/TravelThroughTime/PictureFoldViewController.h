//
//  PictureFoldViewController.h
//  TravelThroughTime
//
//  Created by logan on 2018/1/22.
//  Copyright © 2018年 gs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiFoldView.h"
@interface PictureFoldViewController : UIViewController<MultiFoldViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *foldViewArr;
    NSMutableArray *imgArr;
    
    NSInteger curIndex;
    NSInteger transIndex;
    NSInteger totalNum;

}

@end
