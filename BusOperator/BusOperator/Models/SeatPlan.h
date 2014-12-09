//
//  SeatPlan.h
//  BusOperator
//
//  Created by Macbook Pro on 6/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"
#import "Seat.h"

@interface SeatPlan : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* seat_no;
@property (strong, nonatomic) NSString* bus_no;
@property (strong, nonatomic) NSString* row;
@property (strong, nonatomic) NSString* column;
@property (strong, nonatomic) NSString* classes;
@property (strong, nonatomic) NSArray<Seat, Optional> *seat_list;

@end
