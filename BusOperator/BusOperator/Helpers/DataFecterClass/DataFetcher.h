//
//  DataFetcher.h
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataFetcher : NSObject

- (void)getAllTrips;
- (void)getAllCities;
- (void)getAllBusClasses;
- (void)getAllAgents;
- (void)createTrip:(NSDictionary *)paradict;
- (void)getTripDetail:(NSString*)fromid withTo:(NSString*)toid;
- (void)getTicketTypeList;
- (void)getAllOperatorsList;
- (void)getAllAgentGroups;
- (void)getCommissionType;

- (void)createSeatlayoutwithTicketid:(int)ticketid withrow:(int)numRow withCol:(int)numCol withStatus:(NSString*)strStatus;
- (void)createSeatPlanWithTicketid:(int)ticketid withOpid:(int)opid withrow:(int)numRow withCol:(int)numCol withLayoutid:(int)layoutid withSeatList:(NSString*)strStatus;
- (void)createNewAgentWithName:(NSString *)name withPh:(NSString*)ph withAdd:(NSString*)address withComid:(int)comid withCommission:(int)comm withAgentgp:(NSString*)agentgpid;


//ADD NEW
- (void)createNewAgentGroupWithName:(NSString*)name;
- (void)createNewCityWithName:(NSString*)city;
- (void)createNewBusTypeWithType:(NSString*)type;
- (void)createNewOperator:(NSString*)name withAddress:(NSString*)address withPh:(NSString*)ph withEmail:(NSString*)email withPassword:(NSString*)passcode;
- (void)createNewTicketType:(NSString*)type;
- (void)createnewCommissionType:(NSString*)commissiontype;

//REPORT
- (void)getReportAgentListByOpid:(int)opid;
- (void)getReportAgentTripListByFilterWithOpid:(int)opid withAgentid:(int)agentid withFromCity:(NSString*)fromCityid withToCity:(NSString*)toCityid withFromDate:(NSString*)fromDate withToDate:(NSString*)toDate withTime:(NSString*)strTime;
- (void)getReportAgentTripListByBusWithOpid:(int)opid withAgentid:(int)agentid withFromCity:(NSString*)fromCity withToCity:(NSString*)toCity withDate:(NSString*)date withTime:(NSString*)strTime;

- (void)getCitiesWithAgentid:(int)agentid;
- (void)getTimeWithAgentid:(int)agentid;
- (void)getReportAgentSeatNoWithOpid:(int)opid withFromCity:(NSString*)fromCity withToCity:(NSString*)toCity withDate:(NSString*)date withTime:(NSString*)strTime withBusNo:(NSString*)busno;
- (void)getAccessToken;

//TRIP REPORT
- (void)getReportTripListByFilterWithOpid:(int)opid withFromCity:(NSString*)fromCityid withToCity:(NSString*)toCityid withFromDate:(NSString*)fromDate withToDate:(NSString*)toDate withTime:(NSString*)strTime;
- (void)getCitiesWithOpid;
- (void)getTimeWithOpid;
- (void)getReportTripListByBusWithOpid:(int)opid withFromCity:(NSString*)fromCity withToCity:(NSString*)toCity withDate:(NSString*)date withTime:(NSString*)strTime;

//SEAT OCCUPACY REPORT
- (void)getReportSeatPlan:(int)opid withFromCity:(NSString*)idFromCity withToCity:(NSString*)idToCity withDate:(NSString*)strDate withTime:(NSString*)strTime;
//SEAT LAYOUT REPORT
- (void)getSeatLayoutList;

//UPDATE TRIP
- (void)updateTripWithOpid:(NSDictionary*)tripDict;
- (void)deleteTripScheduleWithid:(NSString*)tripscheduleid;

//SEAT PLAN FOR TRIP SCHEDULE
- (void)getSeatPlanForTripScheduleWithOpid:(int)opid;

//Daily Report
- (void)getDailyReportByTime:(NSString*)today;
- (void)getDailyReportByBus:(NSString*)time withDate:(NSString*)date;
- (void)getDailyReportBySeat:(NSString*)busid;

//Advance Report
- (void)getAdvanceReportByDate:(NSString*)date;
- (void)getAdvanceReportByTime:(NSString*)departureDate withDate:(NSString*)date;

//Customer list with opid
- (void)getCustomerListWithOpid;

//Update
- (void)updateCityWithid:(NSString*)cityid withName:(NSString*)cityname;
- (void)updateAgentGroupWithid:(NSString*)groupid withName:(NSString*)groupname;
- (void)updateBusTypeWithid:(NSString*)bustypeid withName:(NSString*)bustypename;
- (void)updateTicketTypeWithid:(NSString*)tickettypeid withName:(NSString*)tickettypename;
- (void)updateAgentWithDictionary:(NSDictionary*)dict;
- (void)updateOperatorWithDictionary:(NSDictionary*)dict;
- (void)updateCommissiontypeWithDictionary:(NSDictionary*)dict;

//Delete
- (void)deleteAgentGroupWithid:(NSString*)groupid;
- (void)deleteCityWithid:(NSString*)cityid;
- (void)deleteBusTypeWithid:(NSString*)bustypeid;
- (void)deleteAgentWithid:(int)agentid;
- (void)deleteTicketTypeWithid:(NSString*)tickettypeid;
- (void)deleteOperatorWithid:(NSString*)opid;
- (void)deleteCommissionTypeWithid:(NSString*)comid;

//Get Departure Report
- (void)getDepartureBusReport:(NSDictionary*)dict;
- (void)getDepartureAgentReport:(NSString*)busid;
- (void)getDepartureSeatReport:(NSString*)busid withAgentid:(NSString*)agentid;

//BUS SCHEDULE
- (void)getBusSchedule:(NSDictionary*)dict;
- (void)updateBusSchedule:(NSDictionary*)dict;
- (void)deleteBusScheduleWithid:(NSString*)scheduleid;

//HOLIDAY
- (void)addHoliday:(NSDictionary*)dict;
- (void)updateHoliday:(NSDictionary*)dict;
- (void)getHoliday:(NSString*)tripid;
- (void)deleteHolidayWithTripid:(NSString*)tripid withHolidayid:(NSString*)holidayid;

//POPULAR REPORTS
- (void)getPopularTripReport:(NSDictionary*)infodict;
- (void)getPopularTripTimeReport:(NSDictionary*)infodict;
- (void)getPopularAgentReport:(NSDictionary*)infodict;
- (void)getPopularBusType:(NSDictionary*)infodict;

//CREDIT AGENT REPORTS
- (void)getCreditAgentList;

- (void)postAgentCredit:(NSDictionary*)dict;
- (void)getTriplistWithFromto;

- (void)postAgentCommission:(NSDictionary*)dict;
- (void)postPrepaid:(NSDictionary*)dict;

- (void)getCommission:(int)agentid;

- (void)getPaymentHistory:(int)agentid;

- (void)getCreditList:(NSDictionary*)dict;

- (void)postChangeBusGate:(NSDictionary*)dict;

- (void)postDeleteOrder:(NSString*)orderid;

- (void)postPayment:(NSDictionary*)dict;

@end
