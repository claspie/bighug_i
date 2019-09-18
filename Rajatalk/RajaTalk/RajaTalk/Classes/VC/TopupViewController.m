//
//  TopupViewController.m
//  RajaTalk
//
//  Created by WangYing on 2018/7/21.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "Constants.h"
#import "TopupViewController.h"
#import "Util.h"
#import <MBProgressHUD.h>

@interface TopupViewController () <UIWebViewDelegate>

@end

@implementation TopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTopupPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTopupPage {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *pageUrl = BASE_URL_PRODUCTION;
    pageUrl = [pageUrl stringByAppendingString:@"/apptopup?imei="];
    pageUrl = [pageUrl stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    pageUrl = [pageUrl stringByAppendingString:@"&appphonenumber="];
    pageUrl = [pageUrl stringByAppendingString:[Util getAccount].phone];
    pageUrl = [pageUrl stringByAppendingString:@"&app_i_account="];
    pageUrl = [pageUrl stringByAppendingString:[Util getAccount].i_account];
    
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
