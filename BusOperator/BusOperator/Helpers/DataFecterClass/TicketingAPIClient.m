//
//  TicketingAPIClient.m
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TicketingAPIClient.h"

@implementation TicketingAPIClient

+ (instancetype)sharedClient
{
    static TicketingAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TicketingAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.120/"]];
    });
    
    return _sharedClient;
}


@end
