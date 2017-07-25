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

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [FCHCacheURLProtocol startListeningNetWorking];
    
    FCHRequest *request = [FCHRequest requestWithURL:[NSURL URLWithString:@"https://tw-ios.adnonstop.com/beauty/app/wap/camhomme/beta/public/index.php?r=ContentCenter/Index&id=22"]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    request.tag = 999;
    
    [webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
