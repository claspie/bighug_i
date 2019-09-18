//
//  Account.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/23.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "Account.h"

@implementation Account

- (id)initWithCoder:(NSCoder*)decoder {
    self.id = [decoder decodeObjectForKey:@"id"];
    self.phone = [decoder decodeObjectForKey:@"phone"];
    self.i_account = [decoder decodeObjectForKey:@"i_account"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.i_account forKey:@"i_account"];
}

- (void)setAccount:(NSDictionary*)accountInfo {
    self.id = accountInfo[@"id"];
    self.phone = accountInfo[@"phone"];
    self.i_account = accountInfo[@"i_account"];
}

@end
