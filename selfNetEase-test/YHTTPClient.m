//
//  YHTTPClient.m
//  selfNetEase-test
//
//  Created by yihl on 1/30/16.
//  Copyright © 2016 yihl. All rights reserved.
//

#import "YHTTPClient.h"

@implementation YHTTPClient
+(YHTTPClient *)sharedYHTTPClient{
    static YHTTPClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@""];
        //NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/"];
        instance=[[self alloc]initWithBaseURL:url];
        //instance.responseSerializer=[AFJSONResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;

}
@end
