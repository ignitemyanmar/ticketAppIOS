//
//  EditTripListVC.h
//  BusOperator
//
//  Created by Macbook Pro on 5/27/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface EditTripListVC : UIViewController

@property (strong, nonatomic) NSString *strTrip;
@property (strong, nonatomic) Trip* tripObj;
@property (strong, nonatomic) NSMutableArray *dataFiller;
@property (strong, nonatomic) NSString* fromCity;
@property (strong, nonatomic) NSString* toCity;
@property (strong, nonatomic) NSString* fromid;
@property (strong, nonatomic) NSString* toid;

@end
