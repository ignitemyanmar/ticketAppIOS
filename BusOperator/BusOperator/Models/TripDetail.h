//
//  TripDetail.h
//  BusOperator
//
//  Created by Macbook Pro on 6/3/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface TripDetail : JSONModel

@property (assign, nonatomic) int operator_id;
@property (strong, nonatomic) NSString *operator;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSArray<Optional> *trips;

@end
