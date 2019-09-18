//
//  Util.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/20.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "Util.h"
#import "Constants.h"

@implementation Util

+ (BOOL)isRememberLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"is_remember_login"];
//    NSData* data = [JNKeychain loadValueForKey:@"is_remember_login"];
//    if (data != nil) {
//        NSNumber* value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        return [value boolValue];
//    } else {
//        return NO;
//    }
}

+ (void)setRememberLogin:(BOOL)rememberLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:rememberLogin forKey:@"is_remember_login"];
//    NSNumber* value = [NSNumber numberWithBool:rememberLogin];
//    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:value];
//    [JNKeychain saveValue:data forKey:@"is_remember_login"];
}

+ (NSString*)getToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Token"];
}

+ (void)setToken:(NSString*)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (double)getBalance {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Balance"];
}

+ (void)setBalance:(double)balance {
    [[NSUserDefaults standardUserDefaults] setDouble:balance forKey:@"Balance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (Account*)getAccount {
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"Account"];
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return account;
}

+ (void)setAccount:(Account*)account {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:account];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"Account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getLocalAccessNumber {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"LocalAccessNumber"];
}

+ (void)setLocalAccessNumber:(NSInteger)localAccessNumber {
    [[NSUserDefaults standardUserDefaults] setInteger:localAccessNumber forKey:@"LocalAccessNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getRealPhoneNumber:(NSString *)phone {
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    
    return [[phone componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
}

+ (BOOL)isTopupAvailable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TopupAvailable"];
}

+ (void)setTopupAvailable:(NSString*)can {
    BOOL bAvailable = [can isEqualToString:@"1"];
    [[NSUserDefaults standardUserDefaults] setBool:bAvailable forKey:@"TopupAvailable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)readPhone {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"PhoneNumber"];
//    NSData* data = [JNKeychain loadValueForKey:@"PhoneNumber"];
//    if (data != nil) {
//        NSString* value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        return value;
//    } else {
//        return @"";
//    }
}

+ (void)savePhone:(NSString*)phone {
    [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"PhoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:phone];
//    [JNKeychain saveValue:data forKey:@"PhoneNumber"];
}

+ (NSString*)readPassword {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];
//    NSData* data = [JNKeychain loadValueForKey:@"Password"];
//    if (data != nil) {
//        NSString* value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        return value;
//    } else {
//        return @"";
//    }
}

+ (void)savePassword:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:password];
//    [JNKeychain saveValue:data forKey:@"Password"];
}

+ (NSString*)getDateString:(NSDate*)date withFormat:(NSString*)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *stringFromTime = [dateFormatter stringFromDate:date];
    return stringFromTime;
}

@end
