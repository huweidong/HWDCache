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
                     cacheData:(void (^_Nullable)(NSData * _Nonnull cacheData))cacheData
                      progress:(void (^_Nullable)(NSProgress * _Nonnull progress))uploadProgress
                       success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *_Nullable)URLString
                            parameters:(nullable id)parameters
                             cacheData:(void (^_Nullable)(NSData * _Nonnull cacheData))cacheData
                              progress:(nullable void (^)(NSProgress * _Nullable downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

@end
