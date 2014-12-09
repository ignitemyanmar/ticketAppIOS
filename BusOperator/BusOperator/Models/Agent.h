//
//  Agent.h
//  BusOperator
//
//  Created by Macbook Pro on 6/3/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface Agent : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *commission_id;
@property (assign, nonatomic) int agentgroup_id;
@property (strong, nonatomic) NSString *agentgroup;
@property (strong, nonatomic) NSString *commissiontype;
@property (assign, nonatomic) int commission;

@end
