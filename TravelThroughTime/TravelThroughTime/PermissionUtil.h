//
//  PermissionUtil.h
//  TravelThroughTime
//
//  Created by logan on 2018/1/15.
//  Copyright © 2018年 gs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionUtil : NSObject
+ (instancetype) sharedInstance;
- (void)requestAccessForCamera:(void(^)(BOOL granted))callback;
@end
