//
//  BaseViewController.h
//  Rabbtel
//
//  Created by WangYing on 2018/7/20.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void) presentAlert:(NSString *)title message:(NSString *)message;
- (void) presentAlertAndPopVC:(NSString *)title message:(NSString *)message;

@end
