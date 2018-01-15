//
//  PermissionUtil.m
//  TravelThroughTime
//
//  Created by logan on 2018/1/15.
//  Copyright © 2018年 gs. All rights reserved.
//

#import "PermissionUtil.h"
#import <AVFoundation/AVFoundation.h>
@implementation PermissionUtil
+ (instancetype) sharedInstance{
    static PermissionUtil* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PermissionUtil alloc]init];
    });
    return instance;
}
- (void)requestAccessForCamera:(void(^)(BOOL granted))callback{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                callback(granted);
            }];
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        {
            callback(NO);
        }
            break;
            case AVAuthorizationStatusAuthorized:
        {
            callback(YES);
        }
            break;
        default:
            break;
    }
}
@end
