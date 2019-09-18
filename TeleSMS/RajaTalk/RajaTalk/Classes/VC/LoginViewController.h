//
//  ViewController.h
//  RajaTalk
//
//  Created by WangYing on 2018/7/6.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIView *chkRememberView;
@property (weak, nonatomic) IBOutlet UIView *chkShowPwdView;
@property (nonatomic) BEMCheckBox *checkRemember;
@property (nonatomic) BEMCheckBox *checkShowPassword;

@end

