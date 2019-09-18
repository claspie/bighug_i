//
//  CallRecord.h
//  Rabbtel
//
//  Created by Wang Xin on 2019/4/24.
//  Copyright © 2019 Teleclub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallRecord : NSObject

@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *accessNumber;
@property (nonatomic) NSString *calledTime;

+(instancetype)initWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END
