//
//  FCHCacheURLProtocol.m
//  JWNetCache
//
//  Created by huweidong on 16/8/19.
//  Copyright © 2016年 huweidong. All rights reserved.
//



#import "FCHCacheURLProtocol.h"
#import "SDImageCache.h"

@interface JWUrlCacheConfig: NSObject

@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *config;//config是全局的，所有的网络请求都用这个config
@property (readwrite, nonatomic, strong) NSOperationQueue *forgeroundNetQueue;

@end

@implementation JWUrlCacheConfig



- (NSURLSessionConfiguration *)config{
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _config;
}


- (NSOperationQueue *)forgeroundNetQueue{
    if (!_forgeroundNetQueue) {
         _forgeroundNetQueue = [[NSOperationQueue alloc] init];
        _forgeroundNetQueue.maxConcurrentOperationCount = 10;
    }
    return _forgeroundNetQueue;
}

+ (instancetype)instance{
    static JWUrlCacheConfig *urlCacheConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlCacheConfig = [[JWUrlCacheConfig alloc] init];
    });
    return urlCacheConfig;
}


@end

static NSString * const URLProtocolAlreadyHandleKey = @"alreadyHandle";
static NSString * const checkUpdateInBgKey = @"checkUpdateInBg";

@interface FCHCacheURLProtocol()

@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableData *data;
@property (readwrite, nonatomic, strong) NSURLResponse *response;

@end

@implementation FCHCacheURLProtocol

+ (void)startListeningNetWorking{
    [NSURLProtocol registerClass:[FCHCacheURLProtocol class]];
}

+ (void)cancelListeningNetWorking{
    [NSURLProtocol unregisterClass:[FCHCacheURLProtocol class]];
}

+ (void)setConfig:(NSURLSessionConfiguration *)config{
    [[JWUrlCacheConfig instance] setConfig:config];
}


+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *urlScheme = [[request URL] scheme];
    if ([urlScheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [urlScheme caseInsensitiveCompare:@"https"] == NSOrderedSame){
        //判断是否标记过使用缓存来处理，或者是否有标记后台更新
        if ([NSURLProtocol propertyForKey:URLProtocolAlreadyHandleKey inRequest:request] || [NSURLProtocol propertyForKey:checkUpdateInBgKey inRequest:request]) {
            return NO;
        }
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

- (void)netRequestWithRequest:(NSURLRequest *)request {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[JWUrlCacheConfig instance].forgeroundNetQueue];
    NSURLSessionDataTask * sessionTask = [self.session dataTaskWithRequest:request];
    if (self.request.URL.absoluteString) {
        [sessionTask resume];
    }
    
}


- (void)startLoading {
    NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
    
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolAlreadyHandleKey inRequest:mutableRequest];
    
    [self netRequestWithRequest:mutableRequest];
}

- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)appendData:(NSData *)newData {
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }
    else {
        [[self data] appendData:newData];
    }
}

- (void)saveDataToCache:(NSData *)data forURL:(NSURL *)url {
    if (data && url) {
        NSString *key = [url absoluteString];
        SDImageCache *dataCache = [SDImageCache sharedImageCache];
        [dataCache storeImageDataToDisk:data forKey:key];
    }
}

#pragma mark -NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
    
    [self appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.response = response;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        NSCachedURLResponse *urlResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:[self request]];
        if (urlResponse) {
            [self.client URLProtocol:self didReceiveResponse:urlResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            if (urlResponse.data) {
                [self.client URLProtocol:self didLoadData:urlResponse.data];
                [self.client URLProtocolDidFinishLoading:self];
            }else{
                [self.client URLProtocol:self didFailWithError:error];
            }
        }else{
            [self.client URLProtocol:self didFailWithError:error];
        }
    } else {
        [self.client URLProtocolDidFinishLoading:self];
        if (!self.data) {
            return;
        }
        NSCachedURLResponse *cacheUrlResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:self.data];
        [[NSURLCache sharedURLCache] storeCachedResponse:cacheUrlResponse forRequest:self.request];
        [self saveDataToCache:self.data forURL:self.request.URL];
        self.data = nil;
    }
}


@end
