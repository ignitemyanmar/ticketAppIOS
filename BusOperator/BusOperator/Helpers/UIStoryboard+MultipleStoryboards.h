//
//  UIStoryboard+MultipleStoryboards.h
//  BusOperator
//
//  Created by Macbook Pro on 5/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (MultipleStoryboards)

+ (UIStoryboard *)getAgentsStoryboard;
+ (UIStoryboard *)getTripsStoryboard;
+ (UIStoryboard *)getSeatOccupacyStoryboard;
+ (UIStoryboard *)getBusScheduleStoryboard;
+ (UIStoryboard *)getCheckBusScheduleStoryboard;
+ (UIStoryboard *)getReportTabStoryboard;
+ (UIStoryboard *)getManageTabStoryboard;
+ (UIStoryboard *)getTripListTabStoryboard;
+ (UIStoryboard *)getAgentTabStoryboard;
+ (UIStoryboard *)getCustomerListStoryboard;
+ (UIStoryboard *)getManagePriceTabStoryboard;
+ (UIStoryboard *)getSeatPlanStoryboard;
+ (UIStoryboard *)getAddNewStoryboard;
+ (UIStoryboard *)getDailyReportStoryboard;
+ (UIStoryboard *)getDepartureReportStoryboard;

@end
