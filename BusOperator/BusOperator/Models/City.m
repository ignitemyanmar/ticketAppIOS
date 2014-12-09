//
//  City.m
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "City.h"
#import "TicketingAPIClient.h"

@implementation City

+ (void)getAllCity:(void (^)(NSArray *, NSError *))callback
{
    [[TicketingAPIClient sharedClient] getPath:@"city" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray* dataArr = JSON[@"cities"];
        NSMutableArray* resultArr = [NSMutableArray new];
        
        for (NSDictionary *dataDict in dataArr) {
            City* city = [[City alloc] initWithDictionary:dataDict error:nil];
            [resultArr addObject:city];
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

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.name forKey:@"name"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}



@end
