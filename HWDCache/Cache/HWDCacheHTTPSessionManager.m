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

+ (HWDCacheHTTPSessionManager *)sharedManager {
    static HWDCacheHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[HWDCacheHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval=10;
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    });
    return manager;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      cacheData:(void (^)(NSData * _Nonnull))cacheData
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSData *myCacheData = [self loadCacheDataWithKey:URLString];
    cacheData(myCacheData);
    
    NSURLSessionDataTask *dataTask = [self POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [self saveCacheDataWithKey:URLString saveData:responseObject];
        }
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    return dataTask;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                             cacheData:(void (^)(NSData * _Nonnull))cacheData
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    NSData *myCacheData = [self loadCacheDataWithKey:URLString];
    cacheData(myCacheData);
    
    NSURLSessionDataTask *dataTask = [self GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [self saveCacheDataWithKey:URLString saveData:responseObject];
        }
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    return dataTask;
}


#pragma mark - CacheData Deal

- (NSData *)loadCacheDataWithKey :(NSString *)key {
    if (key) {
        SDImageCache *cacheManage = [SDImageCache sharedImageCache];
        NSData *myCacheData = [cacheManage imageFromDiskCacheForKey:key];
        return myCacheData;
    }else{
        return nil;
    }
}

- (void)saveCacheDataWithKey :(NSString *)key saveData:(id _Nullable)saveData {
    if (saveData) {
        SDImageCache *dataCache = [SDImageCache sharedImageCache];
        [dataCache storeImageDataToDisk:saveData forKey:key];
    }
}

- (void)removeCacheDataForKey :(NSString *)key {
    if (key) {
        SDImageCache *dataCache = [SDImageCache sharedImageCache];
        [dataCache removeImageForKey:key];
    }
}

@end
