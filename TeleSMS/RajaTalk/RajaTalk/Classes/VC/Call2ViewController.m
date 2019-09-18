//
//  Call2ViewController.m
//  RajaTalk
//
//  Created by WangYing on 2018/9/4.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "Constants.h"
#import "Call2ViewController.h"
#import "Util.h"
#import <MBProgressHUD.h>

@interface Call2ViewController () <UIWebViewDelegate>

@end

@implementation Call2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadCall2Page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCall2Page {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *pageUrl = BASE_URL_PRODUCTION;
    pageUrl = [pageUrl stringByAppendingString:@"/msms/index?imei="];
    pageUrl = [pageUrl stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    pageUrl = [pageUrl stringByAppendingString:@"&appphonenumber="];
    pageUrl = [pageUrl stringByAppendingString:[Util getAccount].phone];
    pageUrl = [pageUrl stringByAppendingString:@"&app_i_account="];
    pageUrl = [pageUrl stringByAppendingString:[Util getAccount].i_account];
    pageUrl = [pageUrl stringByAppendingString:@"&fromapp=1"];
    pageUrl = [pageUrl stringByAppendingString:@"&apptype=ios"];

    NSURL *url = [NSURL URLWithString:pageUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
