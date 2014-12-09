//
//  Trip.h
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface Trip : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* operator_id;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) NSString* to;
@property (strong, nonatomic) NSString* operator;
@property (strong, nonatomic) NSString* from_city;
@property (strong, nonatomic) NSString* to_city;
@property (strong, nonatomic) NSString* classes;
@property (strong, nonatomic) NSString* available_day;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSString* class_id;
@property (strong, nonatomic) NSString* price;

+ (void)getAllTrips:(void (^)(NSArray *, NSError *))callback;

@end
