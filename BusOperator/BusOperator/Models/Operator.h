//
//  Operator.h
//  BusOperator
//
//  Created by Macbook Pro on 6/13/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface Operator : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSDictionary<Optional>* login_info;

@end
