//
//  Customer.h
//  BusOperator
//
//  Created by Macbook Pro on 6/23/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "JSONModel.h"

@interface Customer : JSONModel

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* nrc_no;
@property (strong, nonatomic) NSString* phone;

@end
