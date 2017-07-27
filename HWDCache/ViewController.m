//
//  ViewController.m
//  HWDCache
//
//  Created by echo_hu on 20/7/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "FCHCacheURLProtocol.h"
#import "SDImageCache.h"
#import "HWDCacheHTTPSessionManager.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [FCHCacheURLProtocol startListeningNetWorking];
//    
//    FCHRequest *request = [FCHRequest requestWithURL:[NSURL URLWithString:@"https://tw.adnonstop.com/beauty/app/wap/camhomme/beta/public/index.php?r=ContentCenter/Index&id=28"]];
//    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    webView.delegate = self;
//    [self.view addSubview:webView];
//    request.tag = 999;
//    
//    [webView loadRequest:request];
    
    //请求发送到的路径
    NSString *url = @"https://tw-ios.adnonstop.com/beauty/app/api/camhomme/biz/beta/api/public/index.php?r=Init/AppConfig&req=eyJpc19lbmMiOjAsImN0aW1lIjoxNTAxMDUzODkxLjQ0MTczLCJvc190eXBlIjoiaW9zIiwiZGV2aWNlIjoiaVBvZCBUb3VjaCA2RyIsIklNRUkiOiI3RkVDRUZEQS0xQTVFLTQxQzYtQTAxNy0wQjJDMEUzMEQ1QTkiLCJ2ZXJzaW9uIjoiMS4wLjAiLCJwYXJhbSI6e30sImFwcF9uYW1lIjoiY2FtaG9tbWVfaXBob25lIiwic2lnbl9jb2RlIjoiMmJkN2I2NGU1YzQ0YmQyYzA4ZiJ9";
    
    NSDictionary *para=nil;
    
    
    [[HWDCacheHTTPSessionManager sharedManager] GET:url parameters:para cacheData:^(NSData * _Nonnull cacheData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheData options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"%@",dict);
    } progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"3333333");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"444444");
    }];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
