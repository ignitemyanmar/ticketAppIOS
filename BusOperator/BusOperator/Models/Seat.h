//
//  Seat.h
//  BusOperator
//
//  Created by Macbook Pro on 6/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@protocol Seat
@end

@interface Seat : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* seat_no;
@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* price;
@property (strong, nonatomic) NSDictionary<Optional>* customer;

@end
