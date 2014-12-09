//
//  TicketingAPIClient.h
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AFHTTPClient.h"

@interface TicketingAPIClient : AFHTTPClient

+ (instancetype)sharedClient;

@end
