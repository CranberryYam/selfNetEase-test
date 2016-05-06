//
//  YHTTPClient.h
//  selfNetEase-test
//
//  Created by yihl on 1/30/16.
//  Copyright © 2016 yihl. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface YHTTPClient : AFHTTPSessionManager
+(YHTTPClient *)sharedYHTTPClient;
@end
