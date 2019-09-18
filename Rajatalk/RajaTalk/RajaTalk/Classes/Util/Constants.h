//
//  Constants.h
//  RajaTalk
//
//  Created by WangYing on 2018/7/20.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define BASE_URL_PRODUCTION     @"http://rajatalk.com"
//#define BASE_URL_PRODUCTION     @"http://204.244.129.38"

#define PARAM_PHONE             @"phone"
#define PARAM_PASSWORD          @"password"
#define PARAM_IMEI              @"imei"
#define PARAM_TOKEN             @"token"
#define PARAM_SIM               @"sim"
#define PARAM_TYPE              @"type"
#define PARAM_PUSH_TOKEN        @"pushtoken"

#define API_SIGN_IN             @"/api/guest/login"
#define API_SIGN_UP             @"/api/guest/signup"
#define API_BALANCE             @"/api/account/balance"
#define API_BLOCKING            @"/api/guest/blocking"
#define API_UNBLOCKING          @"/api/guest/unblocking"
#define API_GET_CANTOPUP        @"/api/account/getcantopup"
#define API_SET_CANTOPUP        @"/api/account/setcantopup"
#define API_RESET_PASSWORD      @"/api/guest/passrecover"
#define API_SET_CONTACTS        @"/api/contact/setcontacts"
#define API_SAVE_TOKEN          @"/api/guest/pushtoken"


#endif /* Constants_h */
