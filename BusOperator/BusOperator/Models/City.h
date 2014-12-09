//
//  City.h
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface City : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;

+ (void)getAllCity:(void(^)(NSArray *cities, NSError *error))callback;

@end
