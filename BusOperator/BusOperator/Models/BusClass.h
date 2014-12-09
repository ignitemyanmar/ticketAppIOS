//
//  BusClass.h
//  BusOperator
//
//  Created by Macbook Pro on 6/3/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface BusClass : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString* operator_id;

@end
