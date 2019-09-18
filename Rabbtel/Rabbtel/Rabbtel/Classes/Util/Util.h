//
//  Util.h
//  Rabbtel
//
//  Created by WangYing on 2018/7/20.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Account.h"
#import <JNKeychain/JNKeychain.h>

@interface Util : NSObject

+ (BOOL)isRememberLogin;
+ (void)setRememberLogin:(BOOL)rememberLogin;

+ (NSString*)readPhone;
+ (void)savePhone:(NSString*)phone;
+ (NSString*)readPassword;
+ (void)savePassword:(NSString*)password;

+ (NSString*)getToken;
+ (void)setToken:(NSString*)token;

+ (double)getBalance;
+ (void)setBalance:(double)balance;

+ (Account*)getAccount;
+ (void)setAccount:(Account*)account;

+ (NSInteger)getLocalAccessNumber;
+ (void)setLocalAccessNumber:(NSInteger)localAccessNumber;

+ (NSString*)getRealPhoneNumber:(NSString*)phone;

+ (BOOL)isTopupAvailable;
+ (void)setTopupAvailable:(NSString*)can;

+ (NSString*)getDateString:(NSDate*)date withFormat:(NSString*)format;

@end
