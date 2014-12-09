//
//  UIStoryboard+MultipleStoryboards.m
//  BusOperator
//
//  Created by Macbook Pro on 5/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "UIStoryboard+MultipleStoryboards.h"

@implementation UIStoryboard (MultipleStoryboards)

+ (UIStoryboard *)getAgentsStoryboard
{
    return [UIStoryboard storyboardWithName:@"AgentsStoryboard" bundle:nil];
}

+ (UIStoryboard *)getTripsStoryboard
{
    return [UIStoryboard storyboardWithName:@"Trips" bundle:nil];
}

+ (UIStoryboard *)getSeatOccupacyStoryboard
{
    return [UIStoryboard storyboardWithName:@"SeatOccupacy" bundle:nil];
}

+ (UIStoryboard *)getBusScheduleStoryboard
{
    return [UIStoryboard storyboardWithName:@"BusSchedule" bundle:nil];
}

+ (UIStoryboard *)getCheckBusScheduleStoryboard
{
    return [UIStoryboard storyboardWithName:@"CheckBusSchedule" bundle:nil];
}

+ (UIStoryboard *)getReportTabStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)getManageTabStoryboard
{
    return [UIStoryboard storyboardWithName:@"ManageCar&Price" bundle:nil];
}

+ (UIStoryboard *)getTripListTabStoryboard
{
    return [UIStoryboard storyboardWithName:@"TripList" bundle:nil];
}

+ (UIStoryboard *)getAgentTabStoryboard
{
    return [UIStoryboard storyboardWithName:@"AgentTab" bundle:nil];
}

+ (UIStoryboard *)getCustomerListStoryboard
{
    return [UIStoryboard storyboardWithName:@"CustomerListTab" bundle:nil];
}

+ (UIStoryboard *)getManagePriceTabStoryboard
{
    return [UIStoryboard storyboardWithName:@"ManageBusTypePrice" bundle:nil];
}

+ (UIStoryboard *)getSeatPlanStoryboard
{
    return [UIStoryboard storyboardWithName:@"Seatplan" bundle:nil];
}

+ (UIStoryboard *)getAddNewStoryboard
{
    return [UIStoryboard storyboardWithName:@"AddNew" bundle:nil];
}

+ (UIStoryboard *)getDailyReportStoryboard
{
    return [UIStoryboard storyboardWithName:@"DailyReport" bundle:nil];
}

+ (UIStoryboard *)getDepartureReportStoryboard
{
    return [UIStoryboard storyboardWithName:@"DepartureReport" bundle:nil];
}


@end
