//
//  HWDCacheHTTPSessionManager.m
//  HWDCache
//
//  Created by echo_hu on 26/7/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "HWDCacheHTTPSessionManager.h"
#import "SDImageCache.h"

@implementation HWDCacheHTTPSessionManager

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      cacheData:(void (^)(NSData * _Nonnull))cacheData
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    SDImageCache *cacheManage = [SDImageCache sharedImageCache];
    NSData *myCacheData = [cacheManage diskImageDataBySearchingAllPathsForKey:URLString];
    cacheData(myCacheData);
    
    NSURLSessionDataTask *dataTask = [self POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            SDImageCache *dataCache = [SDImageCache sharedImageCache];
            [dataCache storeImageDataToDisk:responseObject forKey:URLString];
        }
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    return dataTask;
}

@end
