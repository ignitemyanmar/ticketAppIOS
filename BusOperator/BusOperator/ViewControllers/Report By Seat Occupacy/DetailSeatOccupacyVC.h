//
//  DetailSeatOccupacyVC.h
//  BusOperator
//
//  Created by Macbook Pro on 5/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSeatOccupacyVC : UIViewController

@property (strong, nonatomic) NSArray* seatStatus;
@property (strong, nonatomic) NSArray* seatObjs;
@property (assign, nonatomic) int numRow;
@property (assign, nonatomic) int numCol;

@end
