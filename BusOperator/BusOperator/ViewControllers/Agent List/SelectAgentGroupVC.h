//
//  SelectAgentGroupVC.h
//  BusOperator
//
//  Created by Macbook Pro on 6/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAgentGroupVC : UIViewController

@property (strong, nonatomic) NSArray* tripList;
@property (assign, nonatomic) BOOL isAgentListShowing;
@property (assign, nonatomic) BOOL isTripListShowing;

@end
