//
//  FCHCacheURLProtocol.h
//  JWNetCache
//
//  Created by huweidong on 16/8/19.
//  Copyright © 2016年 huweidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCHRequest.h"

@class SDImageCache;

@interface FCHCacheURLProtocol : NSURLProtocol<NSURLSessionDataDelegate>

//config是全局的，所有的网络请求都用这个config
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *config;

+ (void)startListeningNetWorking;

+ (void)cancelListeningNetWorking;

//config是全局的，所有的网络请求都用这个config，参见NSURLSession使用的NSURLSessionConfiguration
+ (void)setConfig:(NSURLSessionConfiguration *)config;

@end
