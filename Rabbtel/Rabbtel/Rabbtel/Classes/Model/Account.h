//
//  Account.h
//  Rabbtel
//
//  Created by WangYing on 2018/7/23.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *i_account;

- (void)setAccount:(NSDictionary*)accountInfo;

@end
