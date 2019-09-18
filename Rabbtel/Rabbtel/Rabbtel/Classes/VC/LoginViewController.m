//
//  ViewController.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/6.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "LoginViewController.h"
#import <BEMCheckBox.h>
#import <MBProgressHUD.h>
#import "UIColor+Rabbtel.h"
#import "Util.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "Account.h"
#import "SignUpViewController.h"
#import "ResetPasswordViewController.h"
#import "MainViewController.h"

@interface LoginViewController () <BEMCheckBoxDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.checkRemember = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.checkRemember.boxType = BEMBoxTypeSquare;
    self.checkRemember.onTintColor = [UIColor appColor];
    self.checkRemember.onCheckColor = [UIColor appColor];
    [self.chkRememberView addSubview:self.checkRemember];
    self.checkRemember.delegate = self;
    
    self.checkShowPassword = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.checkShowPassword.boxType = BEMBoxTypeSquare;
    self.checkShowPassword.onTintColor = [UIColor appColor];
    self.checkShowPassword.onCheckColor = [UIColor appColor];
    [self.chkShowPwdView addSubview:self.checkShowPassword];
    self.checkShowPassword.delegate = self;

    if ([Util isRememberLogin]) {
        [self.checkRemember setOn:YES];
        [self.tfPhoneNumber setText:[Util readPhone]];
        [self.tfPassword setText:[Util readPassword]];
        [self onSignIn:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignIn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_SIGN_IN];
    
    NSDictionary *params = @{
                             PARAM_PHONE        : self.tfPhoneNumber.text,
                             PARAM_PASSWORD     : self.tfPassword.text,
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_SIM          : @"",
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              BOOL status = [[responseObject objectForKey:@"status"] boolValue];
              if (status) {
                  [Util setToken:responseObject[@"token"]];

                  Account *account = [[Account alloc] init];
                  [account setAccount:responseObject[@"account"]];
                  [Util setAccount:account];

                  [Util savePhone:self.tfPhoneNumber.text];
                  [Util savePassword:self.tfPassword.text];

                  [Util setRememberLogin:self.checkRemember.on];
                  
                  [self showMainScreen];
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

- (IBAction)onSignUp:(id)sender {
//    signupVC
    SignUpViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signupVC"];
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)onTrigger:(id)sender {
    [self.tfPassword becomeFirstResponder];
}

- (IBAction)onTrigger1:(id)sender {
    [self.tfPassword endEditing:YES];
}

- (IBAction)onRemember:(id)sender {
//    [Util setRememberLogin:self.checkRemember.on];
}

- (IBAction)onShowPassword:(id)sender {
    self.tfPassword.secureTextEntry = !self.checkShowPassword.on;
}

- (IBAction)onResetPassword:(id)sender {
//    resetVC
    ResetPasswordViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"resetPwdVC"];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if (self.checkRemember == checkBox) {
        
    } else if (self.checkShowPassword == checkBox) {
        [self.tfPassword setSecureTextEntry:(!self.checkShowPassword.on)];
    }
}

- (void)showMainScreen {
    MainViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainVC"];
    [self presentViewController:vc animated:NO completion:nil];
}

@end
