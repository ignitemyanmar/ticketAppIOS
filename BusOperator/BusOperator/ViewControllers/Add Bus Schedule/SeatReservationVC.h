//
//  SeatReservationVC.h
//  BusOperator
//
//  Created by Macbook Pro on 5/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatReservationVC : UIViewController

@property (strong, nonatomic) NSString* busnumber;
@property (strong, nonatomic) NSString* bustype;
@property (strong, nonatomic) NSString* tripName;
@property (strong, nonatomic) NSString* tripDate;
@property (strong, nonatomic) NSString* tripTime;

@end
