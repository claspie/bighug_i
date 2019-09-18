//
//  MainViewController.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/20.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "MainViewController.h"
#import "CarbonKit.h"
#import "CarbonTabSwipeNavigation.h"
#import "UIColor+Rabbtel.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "Util.h"

@interface MainViewController () <CarbonTabSwipeNavigationDelegate> {
    NSArray *items;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}
@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    items = @[
              @"SMS",
              @"CALL",
              @"TOP-UP"
              ];
    
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:items delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self];
    
    [self style];
    [self getCanTopup];
    [self savePushToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCanTopup {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_GET_CANTOPUP];
    
    NSDictionary *params = @{
                             PARAM_TOKEN        : [Util getToken],
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_SIM          : [Util getAccount].phone,
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
              
              BOOL status = [[responseObject objectForKey:@"status"] boolValue];
              if (status) {
                  NSString *canTopup = responseObject[@"can"];
                  [Util setTopupAvailable:canTopup];
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

- (void)savePushToken {
    NSString* strPushToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"push_token"];
    if (strPushToken == nil || [strPushToken isEqualToString:@""]) {
        return;
    }
    
//    BOOL isSavedToken = [[NSUserDefaults standardUserDefaults] boolForKey:@"saved_token"];
//    if (isSavedToken) {
//        return;
//    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_SAVE_TOKEN];

    
    NSDictionary *params = @{
                             PARAM_PHONE        : [Util getAccount].phone,
                             PARAM_TYPE         : @"ios",
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_PUSH_TOKEN   : strPushToken
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
              
              BOOL status = [[responseObject objectForKey:@"status"] boolValue];
              if (status) {
                  NSArray *res_data = (NSArray * )responseObject[@"messages"];
                  for (NSDictionary * message in res_data) {
//                      [self presentAlert:@"" message:message[@"msg"]];
                      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"saved_token"];
                      break;
                  }
              }
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSString *str = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
              NSLog(@"%@",str);
          }
     ];
}

- (void)style {
    UIColor *color = [UIColor appColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setTabExtraWidth:0];
    [carbonTabSwipeNavigation setTabBarHeight:50];
    
    CGFloat width = self.view.frame.size.width / 3;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:2];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[color colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:15]];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont boldSystemFontOfSize:16]];
    [carbonTabSwipeNavigation setCurrentTabIndex:1];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"call2VC"];

        case 1:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"callVC"];
            
        case 2:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"topupVC"];

        default:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"callVC"];
    }
}

// optional
- (void)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation willMoveAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            self.title = @"SMS";
            break;
        case 1:
            self.title = @"CALL";
            break;
        case 2:
            self.title = @"TOP-UP";
            break;
        default:
            self.title = items[index];
            break;
    }
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    NSLog(@"Did move at index: %lu", (unsigned long)index);
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

@end
