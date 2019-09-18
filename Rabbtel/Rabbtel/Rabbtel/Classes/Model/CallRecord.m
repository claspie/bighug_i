//
//  CallRecord.m
//  Rabbtel
//
//  Created by Wang Xin on 2019/4/24.
//  Copyright © 2019 Teleclub. All rights reserved.
//

#import "CallRecord.h"

@implementation CallRecord

+(instancetype)initWithObject:(id)object {
    CallRecord *callRecord = [[CallRecord alloc] init];
    callRecord.phoneNumber = [object valueForKey:@"phone_number"];
    callRecord.accessNumber = [object valueForKey:@"access_number"];
    callRecord.calledTime = [object valueForKey:@"called_time"];
    
    return callRecord;
}

@end
