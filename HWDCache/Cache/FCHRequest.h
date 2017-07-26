//
//  FCHRequest.h
//  HWDCache
//
//  Created by echo_hu on 20/7/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HWDCacheStrategy) {
    HWDCacheTypeDisk
};

@interface FCHRequest : NSMutableURLRequest

@property (nonatomic ,assign) int tag;

@end
