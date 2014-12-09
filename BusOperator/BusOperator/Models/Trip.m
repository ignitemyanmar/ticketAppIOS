//
//  Trip.m
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "Trip.h"
#import "TicketingAPIClient.h"

@implementation Trip

+ (void)getAllTrips:(void (^)(NSArray *, NSError *))callback
{
    [[TicketingAPIClient sharedClient] getPath:@"city" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray* dataArr = JSON[@"trips"];
        NSMutableArray* resultArr = [NSMutableArray new];
        
        for (NSDictionary *dataDict in dataArr) {
            Trip* trip = [[Trip alloc] initWithDictionary:dataDict error:nil];
            [resultArr addObject:trip];
        }
        
        //        City *carassociation = [[City alloc] initWithDictionary:JSON error:nil];
        if (callback) {
            callback(resultArr, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray new], error);
        }
    }];
}


@end
