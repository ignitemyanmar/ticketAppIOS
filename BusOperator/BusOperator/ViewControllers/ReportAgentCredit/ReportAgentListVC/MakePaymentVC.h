//
//  MakePaymentVC.h
//  BusOperator
//
//  Created by Macbook Pro on 10/28/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakePaymentVC : UIViewController

@property (assign, nonatomic) int agentid;
@property (assign, nonatomic) int prepaidamt;
@property (assign, nonatomic) long totalpayment;
@property (strong, nonatomic) NSString* strorderid;

@end
