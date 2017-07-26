//
//  HWDCacheHTTPSessionManager.h
//  HWDCache
//
//  Created by echo_hu on 26/7/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HWDCacheHTTPSessionManager : AFHTTPSessionManager

+ (HWDCacheHTTPSessionManager *_Nullable)sharedManager;

- (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nullable)URLString
                    parameters:(id _Nullable )parameters
                     cacheData:(void (^_Nullable)(NSData * _Nonnull))cacheData
                      progress:(void (^_Nullable)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

@end
