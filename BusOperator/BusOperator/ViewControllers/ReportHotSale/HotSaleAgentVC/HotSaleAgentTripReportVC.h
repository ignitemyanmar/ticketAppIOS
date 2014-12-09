//
//  HotSaleAgentTripReportVC.h
//  BusOperator
//
//  Created by Macbook Pro on 10/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSaleAgentTripReportVC : UIViewController

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) NSString* fromdate;
@property (strong, nonatomic) NSString* todate;
@property (assign, nonatomic) int agentid;

@end
