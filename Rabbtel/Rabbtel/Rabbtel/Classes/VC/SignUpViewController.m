//
//  SignUpViewController.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/20.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFNetworking.h"
#import "Util.h"
#import "Constants.h"

#import <MBProgressHUD.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onTrigger:(id)sender {
    [self.tfPhoneNumber endEditing:YES];
}

- (IBAction)onSignUp:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_SIGN_UP];
    
    NSDictionary *params = @{
                             PARAM_PHONE        : self.tfPhoneNumber.text,
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              BOOL status = [[responseObject objectForKey:@"status"] boolValue];
              if (status) {
                  
              } else {
                  NSArray *res_data = (NSArray * )responseObject[@"messages"];
                  for (NSDictionary * message in res_data) {
                      [self presentAlert:@"" message:message[@"msg"]];
                      break;
                  }
              }
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSString *str = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
              NSLog(@"%@",str);
          }
     ];
}

@end
