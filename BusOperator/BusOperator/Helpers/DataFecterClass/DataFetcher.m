//
//  DataFetcher.m
//  BusOperator
//
//  Created by Macbook Pro on 6/2/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DataFetcher.h"
#import "Trip.h"
#import "TripDetail.h"
#import "BusClass.h"
#import "Agent.h"
#import "AgentGroup.h"
#import "SeatPlan.h"
#import "Operator.h"
#import "Customer.h"
#import "City.h"
#import "CommissionType.h"

//static NSString * const baseURL = @"http://192.168.1.116/"; //@"http://easyticket.com.mm/"; //

@implementation DataFetcher

- (void)getAllTrips
{
    //easyticket.com.mm
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSLog(@"ACCESS TOKEN : %@", token);
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* urlStr = [NSString stringWithFormat:@"%@trip?access_token=%@&operator_id=%d",baseip,token, operaterid];
    NSURL *url = [NSURL URLWithString:urlStr];//@"http://192.168.1.114/trip"
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dataArr = dict[@"trips"];
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in dataArr) {
                 Trip* trip = [[Trip alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:trip];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishTripsDownload" object:resultArr];
         }
     }];

}

- (void)getAllCities
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@city?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:urlStr];//@"http://192.168.1.114/city"
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dataArr = dict[@"cities"];
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in dataArr) {
                 City* trip = [[City alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:trip];
             }
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"showedetailvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllCityDownload" object:resultArr];
             }
             else if ([currentvc isEqualToString:@"ShowBusSchedule"])
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllCityDownloadFromShowBusSchedule" object:resultArr];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishCityDownload" object:resultArr];
             }
         }
     }];
    
}

- (void)getAllBusClasses
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@busclasses?operator_id=%d&access_token=%@",baseip,operaterid,token];
    NSURL *url = [NSURL URLWithString:urlStr]; //[NSString stringWithFormat:@"http://192.168.1.114/busclasses?operator_id=%d",opid]
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dataArr = dict[@"classes"];
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in dataArr) {
                 BusClass* trip = [[BusClass alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:trip];
             }
             //
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"showedetailvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetAllBusType" object:resultArr];
             }
             else if ([currentvc isEqualToString:@"ShowBusSchedule"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishgetbusclassess" object:resultArr];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishClassDownload" object:resultArr];
             }
         }
     }];

}

- (void)getAllAgents
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@agent?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:urlStr]; //@"http://192.168.1.114/agent"
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);

             NSArray* dataArr = dict[@"agents"];
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in dataArr) {
                 Agent* trip = [[Agent alloc] initWithDictionary:dataDict error:nil];
                 if (trip) {
                     [resultArr addObject:trip];
                 }
                 
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAgentDownload" object:resultArr];
         }
     }];

}

- (void)createTrip:(NSDictionary *)paradict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"operator_id=%d&from=%@&to=%@&class_id=%@&available_day=%@&time=%@&price=%@&seat_plan_id=%d&access_token=%@",operaterid, paradict[@"fromCity"], paradict[@"toCity"], paradict[@"classid"], paradict[@"scheduledate"], paradict[@"time"], paradict[@"price"], [paradict[@"seatplanid"] intValue],token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@trip",baseip];
    NSURL *url = [NSURL URLWithString:str];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);

             NSString* status = dict[@"message"];
//             if (dict) {
//                 status = @"success";
//             }
//             else status = @"fail";
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateTrip" object:status];
         }
     }];
     

}

- (void)createSeatlayoutwithTicketid:(int)ticketid withrow:(int)numRow withCol:(int)numCol withStatus:(NSString*)strStatus
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* str= [NSString stringWithFormat:@"%@seatlayout?ticket_type_id=%d&row=%d&column=%d&seat_list=%@&access_token=%@",baseip,ticketid,numRow,numCol,strStatus,token];
    NSString* postStr = [NSString stringWithFormat:@"ticket_type_id=%d&row=%d&column=%d&seat_list=%@&access_token=%@",ticketid,numRow,numCol,strStatus,token];
    NSString* urlstr = [NSString stringWithFormat:@"%@seatlayout",baseip];
    NSURL *url = [NSURL URLWithString:urlstr];

    NSLog(@"%@", str);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strData);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateSeatLayout" object:dict];
         }
     }];

}

- (void)createSeatPlanWithTicketid:(int)ticketid withOpid:(int)opid withrow:(int)numRow withCol:(int)numCol withLayoutid:(int)layoutid withSeatList:(NSString*)strStatus
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"ticket_type_id=%d&operator_id=%d&row=%d&column=%d&seat_layout_id=%d&seat_list=%@&access_token=%@",ticketid,operaterid,numRow,numCol,layoutid,strStatus,token];
    
    NSString* str = [NSString stringWithFormat:@"%@seatplan",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSString* msg = dict[@"message"];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateSeatPlan" object:msg];
         }
     }];
    
}

- (void)createNewAgentWithName:(NSString *)name withPh:(NSString*)ph withAdd:(NSString*)address withComid:(int)comid withCommission:(int)comm withAgentgp:(NSString*)agentgpid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"name=%@&phone=%@&address=%@&commission_id=%d&commission=%d&agentgroup_id=%@&access_token=%@",name,ph,address,comid,comm,agentgpid,token];
    NSString* poststrwithoutspace = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* str = [NSString stringWithFormat:@"%@agent",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[poststrwithoutspace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateAgent" object:dict];
         }
     }];
    
}



- (void)getTripDetail:(NSString*)fromid withTo:(NSString*)toid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* strurl = [NSString stringWithFormat:@"%@tripsbyfrom-to?from=%@&to=%@&access_token=%@",baseip,fromid,toid,token];
    NSURL *url = [NSURL URLWithString:strurl];
    NSLog(@"urlStr is %@", strurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             TripDetail *tripInfo = [[TripDetail alloc] initWithDictionary:dict error:nil];
             
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"edittriplistvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetTripInfoEditListVC" object:tripInfo];
             }
             else if ([currentvc isEqualToString:@"triplisttabvc"]){
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishTripInfoDownload" object:tripInfo];
             }
         }
     }];

}

- (void)getAllAgentGroups
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* strurl = [NSString stringWithFormat:@"%@agentgroup?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:strurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in dict) {
                 AgentGroup* trip = [[AgentGroup alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:trip];
             }
             
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"showedetailvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllAgentGroupDownload" object:resultArr];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAgentGroup" object:resultArr];
             }
         }
     }];

}
- (void)getCommissionType
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* strurl = [NSString stringWithFormat:@"%@commissiontype?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:strurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dictArr = dict[@"commissiontype_list"];
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in dictArr) {
                 CommissionType* trip = [[CommissionType alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:trip];
             }
             
             
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetCommissionType" object:resultArr];
            
         }
     }];

}

- (void)getTicketTypeList
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSLog(@"ACCESS TOKEN : %@", token);
    NSString* urlStr = [NSString stringWithFormat:@"%@ticket_types?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:urlStr];//@"http://192.168.1.114/trip"
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dataArr = dict[@"ticket_types"];
             
             //             NSMutableArray* resultArr = [NSMutableArray new];
             //
             //             for (NSDictionary *dataDict in dataArr) {
             //                 Trip* trip = [[Trip alloc] initWithDictionary:dataDict error:nil];
             //                 [resultArr addObject:trip];
             //             }
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"showedetailvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetAllTickettype" object:dataArr];
             }
             else if ([currentvc isEqualToString:@"selecttickettypevc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetTicketTypeList" object:dataArr];
             }
         }
     }];
}

- (void)getAllOperatorsList
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSLog(@"ACCESS TOKEN : %@", token);
    NSString* urlStr = [NSString stringWithFormat:@"%@operator?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//@"http://192.168.1.114/trip"
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@" get All operators : %@",strData);
             
             NSArray* dataArr = dict[@"operators"];
             NSMutableArray* muArr = [NSMutableArray new];
             for (NSDictionary* dict in dataArr) {
                 Operator* opObj = [[Operator alloc] initWithDictionary:dict error:nil];
                 [muArr addObject:opObj];
             }
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"operatorshowalleditvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetOperatorList" object:muArr];
             }
             else if ([currentvc isEqualToString:@"selectOperatorListvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetAllOperators" object:muArr];
             }
         }
     }];

}


#pragma mark - ADD NEW Methods

- (void)createNewAgentGroupWithName:(NSString*)name
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"name=%@&access_token=%@",name,token];
    
    NSString* str = [NSString stringWithFormat:@"%@agentgroup",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSArray* dictKey = [dict allKeys];
             NSString* msg = @"Successfully saved!";
             for (NSString* key in dictKey) {
                 if ([key isEqualToString:@"message"]) {
                     msg = dict[@"message"];
                     break;
                 }
             }
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"showedetailvc"]) {
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishNewAgentGroupCreate" object:msg];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateAgentGroup" object:msg];
             }
         }
     }];
}

- (void)createNewCityWithName:(NSString*)city
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"name=%@&access_token=%@",city,token];
    
    NSString* str = [NSString stringWithFormat:@"%@city",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dictKey = [dict allKeys];
             NSString* msg = @"Successfully saved!";
             for (NSString* key in dictKey) {
                 if ([key isEqualToString:@"message"]) {
                     msg = dict[@"message"];
                     break;
                 }
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishNewCityCreate" object:msg];
         }
     }];

}

- (void)createNewBusTypeWithType:(NSString*)type
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"name=%@&operator_id=%d&access_token=%@",type,operaterid,token];
    
    NSString* str = [NSString stringWithFormat:@"%@busclasses",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dictKey = [dict allKeys];
             NSString* msg = @"Successfully saved!";
             for (NSString* key in dictKey) {
                 if ([key isEqualToString:@"message"]) {
                     msg = dict[@"message"];
                     break;
                 }
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishNewBusTypeCreate" object:msg];
         }
     }];
    
}

- (void)createNewOperator:(NSString*)name withAddress:(NSString*)address withPh:(NSString*)ph withEmail:(NSString*)email withPassword:(NSString*)passcode
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"name=%@&address=%@&phone=%@&access_token=%@&email=%@&password=%@",name,address,ph,token,email,passcode];
    NSString* strWithoutSpace = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* str = [NSString stringWithFormat:@"%@operator",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[strWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strData);
             
             NSArray* dictKey = [dict allKeys];
             NSString* msg = @"Successfully saved!";
             for (NSString* key in dictKey) {
                 if ([key isEqualToString:@"message"]) {
                     msg = dict[@"message"];
                     break;
                 }
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateOperator" object:msg];
         }
     }];
    
}

- (void)createNewTicketType:(NSString*)type
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"name=%@&access_token=%@",type,token];
    
    NSString* str = [NSString stringWithFormat:@"%@ticket_types",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dictKey = [dict allKeys];
             NSString* msg = @"Successfully saved!";
             for (NSString* key in dictKey) {
                 if ([key isEqualToString:@"message"]) {
                     msg = dict[@"message"];
                     break;
                 }
             }
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateNewTicketType" object:msg];
         }
     }];

}

- (void)createnewCommissionType:(NSString*)commissiontype
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"commissiontype=%@&access_token=%@",commissiontype,token];
    
    NSString* str = [NSString stringWithFormat:@"%@commissiontype",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSArray* dictKey = [dict allKeys];
             NSString* msg = @"Successfully saved!";
             for (NSString* key in dictKey) {
                 if ([key isEqualToString:@"message"]) {
                     msg = dict[@"message"];
                     break;
                 }
             }
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCreateCommissiontype" object:msg];
         }
     }];

}

#pragma mark - Report Methods

- (void)getReportAgentListByOpid:(int)opid
{
    ///report/operator/agents? operator_id
   NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
//    NSString* urlStr = [NSString stringWithFormat:@"http://easyticket.com.mm/agent?access_token=%@",token];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/agents?operator_id=%d&access_token=%@",baseip,operaterid,token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    NSString* currentvcstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary* myDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSArray* tempArr = myDict[@"agents"];
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in tempArr) {
//                 Agent* trip = [[Agent alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:dataDict];
             }
             if ([currentvcstr isEqualToString:@"HotSaleTripReport"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishdownloadagentHotSaleTrip" object:resultArr];
             } else
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishReportAgentListByOpid" object:resultArr];
         }
     }];

}

- (void)getReportAgentTripListByFilterWithOpid:(int)opid withAgentid:(int)agentid withFromCity:(NSString*)fromCityid withToCity:(NSString*)toCityid withFromDate:(NSString*)fromDate withToDate:(NSString*)toDate withTime:(NSString*)strTime
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/trip?operator_id=%d&from=%@&to=%@&departure_time=%@&start_date=%@&end_date=%@&agent_id=%d&access_token=%@",baseip,operaterid,fromCityid,toCityid,strTime,fromDate,toDate,agentid,token];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             id arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strData);
             
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([arr isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *dataDict in arr) {
                     //                 Agent* trip = [[Agent alloc] initWithDictionary:dataDict error:nil];
                     [resultArr addObject:dataDict];
                 }
             }
             else if ([arr isKindOfClass:[NSDictionary class]]) {
                 
             }
             
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishReportAgentTripListByFilter" object:resultArr];
             
         }
         
     }];

}

- (void)getReportAgentTripListByBusWithOpid:(int)opid withAgentid:(int)agentid withFromCity:(NSString*)fromCity withToCity:(NSString*)toCity withDate:(NSString*)date withTime:(NSString*)strTime
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/trip/date?operator_id=%d&from_city=%@&to_city=%@&date=%@&time=%@&agent_id=%d&access_token=%@",baseip,operaterid,fromCity,toCity,date,strTime,agentid,token];
    NSLog(@"Agent Report By Bus URL : %@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             id arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([arr isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *dataDict in arr) {
                     //                 Agent* trip = [[Agent alloc] initWithDictionary:dataDict error:nil];
                     [resultArr addObject:dataDict];
                 }

             }
             else {
                 
             }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishReportAgentTripListByBus" object:resultArr];
             
         }
         
     }];

}

- (void)getCitiesWithAgentid:(int)agentid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@citiesbyagent?agent_id=%d&access_token=%@",baseip,agentid,token];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strData);
             
             NSMutableArray* resultArr = [NSMutableArray new];
             NSMutableDictionary* muDict = [NSMutableDictionary new];
             NSMutableArray* fromMuArr = [NSMutableArray new];
             NSArray* fromArr = dict[@"from"];
             for (NSDictionary* myDict in fromArr) {
                 City* city = [[City alloc] initWithDictionary:myDict error:nil];
                 [fromMuArr addObject:city];
             }
             
             [muDict setObject:fromMuArr forKey:@"fromCity"];
             
             NSMutableArray* toMuArr = [NSMutableArray new];
             NSArray* toArr = dict[@"to"];
             for (NSDictionary* myDict in toArr) {
                 City* city = [[City alloc] initWithDictionary:myDict error:nil];
                 [toMuArr addObject:city];
             }
             
             [muDict setObject:toMuArr forKey:@"toCity"];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCityListByAgentid" object:muDict];
             
         }
         
     }];

}

- (void)getTimeWithAgentid:(int)agentid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@timesbyagent?agent_id=%d&access_token=%@",baseip,agentid,token];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray* arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([arr isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *dataDict in arr) {
                     [resultArr addObject:dataDict[@"time"]];
                 }
             }
             
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDownloadTimeWithAgentid" object:resultArr];
         }
     }];
}

- (void)getReportAgentSeatNoWithOpid:(int)opid withFromCity:(NSString*)fromCity withToCity:(NSString*)toCity withDate:(NSString*)date withTime:(NSString*)strTime withBusNo:(NSString*)busno
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/seat/trip?operator_id=%d&from_city=%@&to_city=%@&date=%@&time=%@&bus_id=%@&access_token=%@",baseip,operaterid,fromCity,toCity,date,strTime,busno,token];
    //    NSString* urlStr =
    NSLog(@"Detail Info URL = %@", urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             id arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([arr isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *dataDict in arr) {
                     
                   [resultArr addObject:dataDict];
                     

                 }
             }
             else if ([arr isKindOfClass:[NSDictionary class]]) {
                
             }
             NSLog(@"RESULT %@",resultArr);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAgentReportSeatNo" object:resultArr];
             
         }
         
     }];
    
}


#pragma mark - ACCESS TOKEN 

- (void)getAccessToken
{
    //http://easyticket.com.mm/oauth/access_token
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    
    //LOCAL
   NSString* postString = @"grant_type=password&client_id=721685&client_secret=IgniteAdmin721685&username=ignite.dev.team@gmail.com&password=ignitemyanmar&scope=admin&state=123456789";
    
    //GLOBAL
//    NSString* postString = @"grant_type=password&client_id=1&client_secret=ignite-admin&username=ignite.dev.team@gmail.com&password=ignitemyanmar&scope=admin&state=123456789";
//
    NSString* str = [NSString stringWithFormat:@"%@oauth/access_token",baseip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /* {
              "access_token": "9T5TqEAy8H4PY8fKC3RMAywHWFFHtvJHt1QeVW3r",
              "token_type": "bearer",
              "expires": 1404100926,
              "expires_in": 604800,
              "refresh_token": "3QiZrXmWD3ScU2V40JAQfhqm7mJxH7PEu8w2ZSFd",
              "user": {
              "id": "3",
              "name": "Ignite",
              "type": "operator"
              }
              } */
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"GET ACCESS TOKEN = %@",strData);
             
             NSString* token = dict[@"access_token"];
             [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             NSDictionary* userDict = dict[@"user"];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDownloadingToken" object:userDict];
         }
     }];

}

#pragma mark - TRIP REPORT

- (void)getReportTripListByFilterWithOpid:(int)opid withFromCity:(NSString*)fromCityid withToCity:(NSString*)toCityid withFromDate:(NSString*)fromDate withToDate:(NSString*)toDate withTime:(NSString*)strTime
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/trip?operator_id=%d&from=%@&to=%@&departure_time=%@&start_date=%@&end_date=%@&access_token=%@",baseip,operaterid,fromCityid,toCityid,strTime,fromDate,toDate,token];
    NSLog(@"urlStr = %@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             id arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strData);
             
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([arr isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *dataDict in arr) {
                     //                 Agent* trip = [[Agent alloc] initWithDictionary:dataDict error:nil];
                     [resultArr addObject:dataDict];
                 }
             }
             else if ([arr isKindOfClass:[NSDictionary class]]) {
                 
             }
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishTripReportByDate" object:resultArr];
             
         }
         
     }];
    
}

- (void)getCitiesWithOpid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@citiesbyoperator?operator_id=%d&access_token=%@",baseip,operaterid,token];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strData);
             
             NSMutableArray* resultArr = [NSMutableArray new];
             NSMutableDictionary* muDict = [NSMutableDictionary new];
             NSMutableArray* fromMuArr = [NSMutableArray new];
             NSArray* fromArr = dict[@"from"];
             for (NSDictionary* myDict in fromArr) {
                 City* city = [[City alloc] initWithDictionary:myDict error:nil];
                 [fromMuArr addObject:city];
             }
             
             [muDict setObject:fromMuArr forKey:@"fromCity"];
             
             NSMutableArray* toMuArr = [NSMutableArray new];
             NSArray* toArr = dict[@"to"];
             for (NSDictionary* myDict in toArr) {
                 City* city = [[City alloc] initWithDictionary:myDict error:nil];
                 [toMuArr addObject:city];
             }
             
             [muDict setObject:toMuArr forKey:@"toCity"];
             
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"departurereport"]) {
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetCityDepartureReport" object:muDict];
             }
             else if ([currentvc isEqualToString:@"ShowBusSchedule"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllCityDownloadFromShowBusSchedule" object:muDict];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishCityListByOpid" object:muDict];
             }
             
         }
         
     }];
    
}

- (void)getTimeWithOpid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@timesbyoperator?operator_id=%d&access_token=%@",baseip,operaterid,token];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in arr) {
                 [resultArr addObject:dataDict[@"time"]];
             }
             
             NSString* currentvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
             if ([currentvc isEqualToString:@"departurereport"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetTimeDepartureReport" object:resultArr];
             }
             else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetTimeWithOpid" object:resultArr];
             }
         }
     }];
}

- (void)getReportTripListByBusWithOpid:(int)opid withFromCity:(NSString*)fromCity withToCity:(NSString*)toCity withDate:(NSString*)date withTime:(NSString*)strTime
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/trip/date?operator_id=%d&from_city=%@&to_city=%@&date=%@&access_token=%@",baseip,operaterid,fromCity,toCity,date,token];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             
             NSMutableArray* resultArr = [NSMutableArray new];
             
             for (NSDictionary *dataDict in arr) {
                 //                 Agent* trip = [[Agent alloc] initWithDictionary:dataDict error:nil];
                 [resultArr addObject:dataDict];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishReportAgentTripListByBus" object:resultArr];
             
         }
         
     }];
    
}

#pragma mark - SEAT OCCUPACY REPORT

- (void)getReportSeatPlan:(int)opid withFromCity:(NSString*)idFromCity withToCity:(NSString*)idToCity withDate:(NSString*)strDate withTime:(NSString*)strTime
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/operator/seatplan?operator_id=%d&from_city=%@&to_city=%@&date=%@&time=%@&access_token=%@",baseip,operaterid,idFromCity,idToCity,strDate,strTime,token];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([result isKindOfClass:[NSDictionary class]]) {
                 NSArray* arr = result[@"seat_plan"];
                 
                 for (NSDictionary *dataDict in arr) {
                     NSMutableArray* arr = [SeatPlan arrayOfModelsFromDictionaries:@[dataDict]];
                     SeatPlan* seatplanObj = [arr lastObject];
                     [resultArr addObject:seatplanObj];
                 }

             }
             else if ([result isKindOfClass:[NSArray class]]) {
                 
             }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishReportSeatplanDownload" object:resultArr];
             
         }
         
     }];

}

#pragma mark - SEAT LAYOUT DOWNLOAD

//http://easyticket.com.mm/seatlayouts?access_token=St834T0nePt5XWe0PCXTRFuxKQSFPQq4y2T3yGMe

- (void)getSeatLayoutList
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@seatlayouts?access_token=%@",baseip,token];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSMutableArray* resultArr = [NSMutableArray new];
             if ([result isKindOfClass:[NSDictionary class]]) {
                 NSArray* arr = result[@"seat_layouts"];
                 resultArr = [arr copy];
//                 for (NSDictionary *dataDict in arr) {
//                     NSMutableArray* arr = [SeatPlan arrayOfModelsFromDictionaries:@[dataDict]];
//                     SeatPlan* seatplanObj = [arr lastObject];
//                     [resultArr addObject:seatplanObj];
//                 }
                 
             }
             else if ([result isKindOfClass:[NSArray class]]) {
                 
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetSeatLayoutList" object:resultArr];
             
         }
         
     }];
    
}


#pragma mark - UPDATE TRIP

- (void)updateTripWithOpid:(NSDictionary*)tripDict
{
//    http://easyticket.com.mm/trip/1?operator_id=1&from=1&to=3&class_id=1&available_day=daily&price=6500&time=1:00 PM&access_token=TfsOC8a5EzDBLUCcxSt40lfMWVT7sbpJoYcrteCF
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postString = [NSString stringWithFormat:@"operator_id=%d&from=%@&to=%@&class_id=%@&available_day=%@&price=%@&time=%@&seat_plan_id=%d&access_token=%@", operaterid,tripDict[@"fromCity"],tripDict[@"toCity"],tripDict[@"classid"],tripDict[@"scheduledate"],tripDict[@"price"],tripDict[@"time"],[tripDict[@"seatplanid"] intValue],token];
    NSString* urlStr = [NSString stringWithFormat:@"%@trip/%d",baseip,[tripDict[@"tripid"] intValue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString* str = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateTrip" object:str];
         }
     }];

}

- (void)deleteTripScheduleWithid:(NSString*)tripscheduleid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@busoccurance/delete/%@",baseip,tripscheduleid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteTripSchedule" object:msg];
         }
         
     }];

}

#pragma mark - GET SEAT PLAN FOR TRIP SCHEDULE

- (void)getSeatPlanForTripScheduleWithOpid:(int)opid
{//http://easyticket.com.mm/seatplan/tripcreate/1?access_token=rPVp4j5AXh7WB43MLvC61ALYb2lwiZacGVzL9jB3
    //
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@seatplan/tripcreate/%d?access_token=%@",baseip,operaterid,token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSMutableArray* muarr = [NSMutableArray new];
             for (NSDictionary* dict in arr) {
                 [muarr addObject:dict];
            }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetSeatPlanForTripSchedule" object:muarr];
         }
     }];

}

#pragma mark - Daily Report
- (void)getDailyReportByTime:(NSString*)today
{
    //http://easyticket.com.mm/report/bus/daily?access_token=KmT4kyqYhzDHYX05wkFaqLYsY7przT9OuJfe7xPv&from=1&to=3&operator_id=1&date=2014-06-12&access_token=Xf7DisbeoxfN3PjwtBmWC4tMQmdmjgVGmgkiF9qK
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/bus/daily?access_token=%@&operator_id=%d&date=%@",baseip,token,operaterid,today]; //@"2014-06-19"
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*
             "from": "Yangon",
             "to": "Mandalay",
             "time": "10:00 AM",
             "sold_seat": 2,
             "total_seat": 27,
             "price": "15000",
             "sold_amount": 30000
              */
             NSMutableArray* muarr = [NSMutableArray new];
             for (NSDictionary* dict in arr) {
                 [muarr addObject:dict];
             }
             
             NSString* strvc = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
             if ([strvc isEqualToString:@"alldailyreportvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllDailyDepartureReportByTime" object:muarr];
             }
             else if ([strvc isEqualToString:@"DepartureReportvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetDailyReportByTime" object:muarr];
             }
         }
     }];

}

- (void)getDailyReportByBus:(NSString*)time withDate:(NSString*)date
{
//http://easyticket.com.mm/report/bus/daily/time?access_token=bVKSazPwInuY6oz0BO865R3lVuo9Lx5thJmBqjW5&operator_id=1&date=2014-06-20&departure_time=10:00 am
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
//    NSDate* date = [NSDate date];
//    NSString* strToday = [NSString stringWithFormat:@"%@",date];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    NSString* todaydate = [dateFormat stringFromDate:[NSDate date]];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@report/bus/daily/time?access_token=%@&operator_id=%d&date=%@&departure_time=%@",baseip,token,operaterid,date,time];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*
              {
              "bus_id": "3",
              "bus_no": "YGN-9891",
              "from": "Yangon",
              "to": "Mandalay",
              "class": "Special",
              "time": "10:00 AM",
              "sold_seat": 2,
              "total_seat": 27,
              "price": "15000",
              "sold_amount": 30000
              }
              */
             NSMutableArray* muarr = [NSMutableArray new];
             for (NSDictionary* dict in arr) {
                 [muarr addObject:dict];
             }
             
             NSString* strvc = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
             if ([strvc isEqualToString:@"alldailyreportvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllDailyDepartureReportByBus" object:muarr];
             }
             else if ([strvc isEqualToString:@"DepartureReportvc"]) {
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetDailyReportByBus" object:muarr];
             }
         }
     }];

    
}

- (void)getDailyReportBySeat:(NSString*)busid
{
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
//    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/bus/daily/busid?access_token=%@&bus_id=%@",baseip,token,busid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*
              {
              "bus_id": "3",
              "bus_no": "YGN-9891",
              "from": "Yangon",
              "to": "Mandalay",
              "class": "Special",
              "time": "10:00 AM",
              "sold_seat": 2,
              "total_seat": 27,
              "price": "15000",
              "sold_amount": 30000
              }
              */
             NSMutableArray* muarr = [NSMutableArray new];
             for (NSDictionary* dict in arr) {
                 [muarr addObject:dict];
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetDailyReportBySeat" object:muarr];
         }
     }];

}

- (void)getAdvanceReportByDate:(NSString*)date
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
//    NSDate* date = [NSDate date];
//    NSString* strToday = [NSString stringWithFormat:@"%@",date];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    NSString* todaydate = [dateFormat stringFromDate:[NSDate date]];

    NSString* urlStr = [NSString stringWithFormat:@"%@report/soldtrips/advance/daily?access_token=%@&operator_id=%d&date=%@",baseip,token,operaterid,date];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*
              {
              "purchased_total_seat": 8,
              "total_amout": 120000,
              "departure_date": "2014-06-19",
              "total_seat": 27
              }
              */
             NSMutableArray* muarr = [NSMutableArray new];
             for (NSDictionary* dict in arr) {
                 [muarr addObject:dict];
             }
             
             NSString* strvc = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
             if ([strvc isEqualToString:@"alldailyreportvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllAdvanceReportByDate" object:muarr];
             }
             else {
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAdvanceReportByDate" object:muarr];
             }
         }
     }];

}

- (void)getAdvanceReportByTime:(NSString*)departureDate withDate:(NSString*)date
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
//    NSDate* date = [NSDate date];
//    NSString* strToday = [NSString stringWithFormat:@"%@",date];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    NSString* todaydate = [dateFormat stringFromDate:[NSDate date]];
    
    
    NSString* urlStr = [NSString stringWithFormat:@"%@report/soldtrips/advance/daily/date?access_token=%@&operator_id=%d&order_date=%@&departure_date=%@",baseip,token,operaterid,date,departureDate];
    NSLog(@"URLSTR FOR ADvance report by Time = %@", urlStr);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);

             /*
              {
              "purchased_total_seat": 8,
              "total_amout": 120000,
              "bus_id": "2",
              "bus_no": "YGN-9898",
              "departure_date": "2014-06-19",
              "time": "10:00 AM",
              "total_seat": 27
              }
              */
             
             NSMutableArray* muarr = [NSMutableArray new];
             for (NSDictionary* dict in arr) {
                 [muarr addObject:dict];
             }
             
             NSString* strvc = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
             if ([strvc isEqualToString:@"alldailyreportvc"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAllAdvacneReportByTime" object:muarr];
             }
             else {
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAdvacneReportByTime" object:muarr];
             }
         }
     }];

}

- (void)getCustomerListWithOpid
{
    //http://easyticket.com.mm/customer/operator?access_token=lqI59lwREW5ACytKA0LoPi44izLS8ljUDxqkW1hw&operator_id=1
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@customer/operator?access_token=%@&operator_id=%d",baseip,token,operaterid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSMutableArray* muArr = [[NSMutableArray alloc] init];
             
             for (NSDictionary* dict in arr) {
                 Customer* cusobj = [[Customer alloc] initWithDictionary:dict error:nil];
                 [muArr addObject:cusobj];
                 
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetCustomerListWithOpid" object:muArr];
         }
     }];
    
}

#pragma mark - UPDATE METHODS

- (void)updateCityWithid:(NSString*)cityid withName:(NSString*)cityname
{
    //http://easyticket.com.mm/city/12?name=LL&access_token=GuQgh3UziXCQMPennPqbZXr11lsBelIHSylkkeJT
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@",cityname,token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@city/%@",baseip,cityid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateCity" object:msg];
         }
         
     }];
}

- (void)updateAgentGroupWithid:(NSString*)groupid withName:(NSString*)groupname
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@",groupname,token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@agentgroup/update/%@",baseip,groupid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateAgentgroup" object:msg];
         }
         
     }];
}

- (void)updateBusTypeWithid:(NSString*)bustypeid withName:(NSString*)bustypename
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@&operator_id=%d",bustypename,token,operaterid];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@busclasses/update/%@",baseip,bustypeid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
//             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateBusType" object:nil];
         }
         
     }];
}

//http://easyticket.com.mm/ticket_types/update/2

- (void)updateTicketTypeWithid:(NSString*)tickettypeid withName:(NSString*)tickettypename
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@",tickettypename,token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket_types/update/%@",baseip,tickettypeid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             //             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateTicketType" object:nil];
         }
         
     }];
}

- (void)updateAgentWithDictionary:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@&phone=%@&address=%@&commission_id=%@&commission=%@",dict[@"name"],token,dict[@"ph"],dict[@"address"],dict[@"comid"],dict[@"com"]];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@agent/update/%@",baseip,dict[@"agentid"]]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateAgent" object:msg];
         }
         
     }];

}

- (void)updateOperatorWithDictionary:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@&phone=%@&address=%@&password=%@&new_password=%@",dict[@"name"],token,dict[@"ph"],dict[@"address"],dict[@"password"], dict[@"newpassword"]];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@operator/update/%@",baseip,dict[@"opid"]]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateOperator" object:msg];
         }
         
     }];
}

- (void)updateCommissiontypeWithDictionary:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"name=%@&access_token=%@",dict[@"name"],token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@commissiontype/update/%@",baseip,dict[@"comid"]]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateCommissiontype" object:msg];
         }
         
     }];

}

#pragma mark - DELETE METHODS

- (void)deleteAgentGroupWithid:(NSString*)groupid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@agentgroup/delete/%@",baseip,groupid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteAgentGroup" object:msg];
         }
         
     }];

}

- (void)deleteCityWithid:(NSString*)cityid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@city/delete/%@",baseip,cityid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteCity" object:msg];
         }
         
     }];
}

- (void)deleteBusTypeWithid:(NSString*)bustypeid
{
    //
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@busclasses/delete/%@",baseip,bustypeid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteBusType" object:msg];
         }
         
     }];

}

- (void)deleteAgentWithid:(int)agentid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@agent/delete/%d",baseip,agentid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteAgent" object:msg];
         }
         
     }];
}

- (void)deleteTicketTypeWithid:(NSString*)tickettypeid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ticket_types/delete/%@",baseip,tickettypeid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteTicketType" object:msg];
         }
         
     }];

}

- (void)deleteOperatorWithid:(NSString*)opid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@operator/delete/%@",baseip,opid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteOperator" object:msg];
         }
         
     }];
}

- (void)deleteCommissionTypeWithid:(NSString*)comid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* postStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSString* postStrWithoutSpace = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@commissiontype/delete/%@",baseip,comid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteCommissiontype" object:msg];
         }
         
     }];

}

#pragma mark - GET DEPARTURE REPORT
- (void)getDepartureBusReport:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/tripdate/operator/daily?access_token=%@&operator_id=%d&departure_date=%@&from=%@&to=%@&time=%@",baseip,token,operaterid,dict[@"date"],dict[@"from"],dict[@"to"],dict[@"time"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*
              {
              "id": "113",
              "bus_no": "YGN-9898",
              "sold_seats": 5,
              "total_seats": 33,
              "total_amount": 75000
              }*/
             
             NSMutableArray* muArr = [[NSMutableArray alloc] init];
             
             for (NSDictionary* dict in arr) {
                 
                 [muArr addObject:dict];
                 
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishgetDepartureBusReport" object:muArr];
         }
     }];


}

- (void)getDepartureAgentReport:(NSString*)busid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/tripdate/operator/busid?access_token=%@&bus_id=%@",baseip,token,busid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*
              {
              "bus_id": "113",
              "agent_id": "0",
              "agent": "-",
              "sold_tickets": 5,
              "total_amount": 75000,
              "total_seats": 33
              }*/
             
             NSMutableArray* muArr = [[NSMutableArray alloc] init];
             
             for (NSDictionary* dict in arr) {
                 
                 [muArr addObject:dict];
                 
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishgetDepartureAgentReport" object:muArr];
         }
     }];
    
    
}

- (void)getDepartureSeatReport:(NSString*)busid withAgentid:(NSString*)agentid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/tripdate/operator/detail?access_token=%@&bus_id=%@&agent_id=%@",baseip,token,busid,agentid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             /*{
              "bus_no": "YGN-9898",
              "trip": "Yangon-Taunggyi",
              "class": "VIP",
              "departure_date": "2014-06-24",
              "departure_time": "07:30 PM",
              "seat_no": "1A",
              "ticket_no": "123456789",
              "orderdate": "2014-06-24",
              "agent": "-",
              "customer_name": "saw",
              "operator": "Shwe Nan Taw",
              "price": "15000"
              }*/

             
             NSMutableArray* muArr = [[NSMutableArray alloc] init];
             
             for (NSDictionary* dict in arr) {
                 
                 [muArr addObject:dict];
                 
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishgetDepartureSeatReport" object:muArr];
         }
     }];

    
}


#pragma mark - BUS SCHEDULE

- (void)getBusSchedule:(NSDictionary*)dict
{
    //http://easyticket.com.mm/report/operator/trip/date?operator_id=1&from_city=1&to_city=12&date=2014-06-25&access_token=CQknIxbC3bjmajcJAImXZ6VeEE4iQyZBWI7SKJkd&time=07:30 PM
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/tripdate/operator/daily?access_token=%@&operator_id=%d&departure_date=%@&from=%@&to=%@",baseip,token,operaterid,dict[@"date"],dict[@"from"],dict[@"to"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"bus schedule data = %@",strData);
             NSString* msg = dict[@"message"];
             NSMutableArray* muArr = [[NSMutableArray alloc] init];
             
             for (NSDictionary* dict in arr) {
                 
                 [muArr addObject:dict];
                 
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishgetBusSchedule" object:muArr];
         }
     }];

}

- (void)updateBusSchedule:(NSDictionary*)dict
{
    //http://easyticket.com.mm/busoccurance/update/1
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"bus_no=%@&class_id=%@&operator_id=%d&access_token=%@",dict[@"busno"],dict[@"classid"],operaterid,token];
    NSString* postStrWithoutSpace = [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@busoccurance/update/%@",baseip,dict[@"scheduleid"]]]];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSString* msg = dict[@"message"];
             
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishupdateBusSchedule" object:msg];
         }
     }];

}

- (void)deleteBusScheduleWithid:(NSString*)scheduleid
{
    //http://easyticket.com.mm/busoccurance/delete/1
    
//    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
//    NSString* urlStr = [NSString stringWithFormat:@"bus_no=%@&class_id=%@&operator_id=%d&access_token=%@",dict[@"busno"],dict[@"classid"],operaterid,token];
//    NSString* postStrWithoutSpace = [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* urlstr = [NSString stringWithFormat:@"access_token=%@", token];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@busoccurance/delete/%@",baseip,scheduleid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[urlstr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteBusSchedule" object:msg];
         }
     }];

}

#pragma mark - HOLIDAY SCHEDULE

- (void)addHoliday:(NSDictionary*)dict
{
    //http://easyticket.dev/triplists/holiday
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSString* urlstr = [NSString stringWithFormat:@"access_token=%@&trip_id=%@&start_date=%@&end_date=%@", token,dict[@"tripid"],dict[@"startdate"],dict[@"enddate"]];
    NSString* poststr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* str = [NSString stringWithFormat:@"%@triplists/holiday",baseip];
    NSURL* url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[poststr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAddHoliday" object:msg];
         }
     }];

}

- (void)updateHoliday:(NSDictionary*)dict
{
    //http://easyticket.com.mm/triplists/holiday/delete
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSString* urlstr = [NSString stringWithFormat:@"access_token=%@&trip_id=%@&holiday_id=%@&start_date=%@&end_date=%@", token,dict[@"tripid"],dict[@"holidayid"],dict[@"startdate"],dict[@"enddate"]];
    NSString* poststr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@triplists/holiday/update",baseip];
    NSURL* url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[poststr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateHoliday" object:msg];
         }
     }];

}

- (void)getHoliday:(NSString*)tripid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@triplists/holiday/trip?access_token=%@&trip_id=%@",baseip,token,tripid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              "trip_id": "1",
              "from_to": "Yangon-Mandalay",
              "time": "10:00 AM",
              "class": "Special",
              "holidays": [
              {
              "from_date": "2014-06-20",
              "to_date": "2014-06-29",
              "holiday_id": "2"
              },
              {
              "from_date": "2014-06-30",
              "to_date": "2014-06-30",
              "holiday_id": "1"
              }
              ]
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetHoliday" object:dict];
         }
     }];

}

- (void)deleteHolidayWithTripid:(NSString*)tripid withHolidayid:(NSString*)holidayid
{
    //http://easyticket.com.mm/triplists/holiday/delete
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSString* urlstr = [NSString stringWithFormat:@"access_token=%@&trip_id=%@&holiday_id=%@", token,tripid, holidayid];
    NSString* poststr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@triplists/holiday/delete",baseip];
    NSURL* url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[poststr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Create Trip Data = %@",strData);
             NSString* msg = dict[@"message"];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteHoliday" object:msg];
         }
     }];

}

#pragma mark - POPULAR REPORTS METHODS

//http://192.168.1.116/report/popular/trip?access_token=ia96CVN7GFfP2KoCBcq7iA0VNlL8PgmPdpInx2gX&operator_id=11&start_date=2014-09-30&end_date=2014-10-2&agent_id=608
- (void)getPopularTripReport:(NSDictionary*)infodict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/popular/trip?access_token=%@&operator_id=%d&start_date=%@&end_date=%@&agent_id=%@",baseip,token,operaterid, infodict[@"startdate"], infodict[@"enddate"], infodict[@"agentid"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              id: 49
              from: 13
              to: 14
              trip: "Yangon - Nay Pyi Taw"
              classes: "Economy"
              percentage: 7
              sold_total_seat: 6
              total_seat: 90
              total_amount: "43200"
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetPopularTrips" object:dict];
         }
     }];
    
}

- (void)getPopularTripTimeReport:(NSDictionary*)infodict
{
    //http://192.168.1.116/report/popular/triptime?access_token=HBlLhhsmo7o9BUTNcPG4wqyqsXlzaHMR1HXY83tb&operator_id=11&start_date=2014-09-30&end_date=2014-10-17&agent_id=&from=13&to=14
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/popular/triptime?access_token=%@&operator_id=%d&start_date=%@&end_date=%@&agent_id=%@&from=%@&to=%@",baseip,token,operaterid, infodict[@"startdate"], infodict[@"enddate"], infodict[@"agentid"], infodict[@"from"], infodict[@"to"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              id: 49
              trip: "Yangon - Nay Pyi Taw"
              time: "06:00 AM"
              classes: "Economy"
              percentage: 1
              sold_total_seat: 6
              total_seat: 765
              total_amount: "43200"
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetPopularTripTime" object:dict];
         }
     }];
    
}

- (void)getPopularAgentReport:(NSDictionary*)infodict
{
    //http://192.168.1.116/report/popular/agent?access_token=CjGDdRqiWDq1dqfwLH7WnKHwvSZaZBnLh5M0tZFu&operator_id=11&start_date=2014-10-01&end_date=2014-10-15
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/popular/agent?access_token=%@&operator_id=%d&start_date=%@&end_date=%@",baseip,token,operaterid, infodict[@"startdate"], infodict[@"enddate"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              "id": 608,
              "name": "1876",
              "total_amount": "138400",
              "count": 6,
              "purchased_total_seat": 12
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetPopularAgent" object:dict];
         }
     }];
    
}

//

- (void)getPopularBusType:(NSDictionary*)infodict
{
    //http://192.168.1.116/report/analytis/classes?access_token=1B617zYakil07D1Girnu9xQCgS92V8OpPEGnrE4X&operator_id=11&start_date=2014-09-30&end_date=2014-10-13&agent_id=608
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@report/analytis/classes?access_token=%@&operator_id=%d&start_date=%@&end_date=%@&agent_id=%@",baseip,token,operaterid, infodict[@"startdate"], infodict[@"enddate"], infodict[@"agentid"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              "id": 19,
              "name": "Business",
              "total_amount": "80800",
              "count": 4,
              "purchased_total_seat": 4
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetPopularBusType" object:dict];
         }
     }];
    
}

//http://192.168.1.116//agentlist/operatorid?access_token=gS9WBIS7UfdO2KFtqJzdBTwhPr3o6nZqVkDpx1UA&operator_id=11

- (void)getCreditAgentList
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@agentlist/operatorid?access_token=%@&operator_id=%d",baseip,token,operaterid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              "id": 606,
              "agentgroup_id": 0,
              "name": "\"Golden Bell Family  Travels & Tours\"",
              "phone": "၀၉၄၉၂၉၂၂၅၈၊ ၀၉၄၂၁၁၃၅၄၅၅",
              "address": "အမွတ္(၁၃၆/၁၃၈)၊ အေနာ္ရထာလမ္း၊ (၄၈)လမ္းႏွင့္ ဗုိလ္ျမတ္ထြန္းလမ္းၾကား၊ ဗိုလ္တေထာင္ျမိဳ႔နယ္၊ ရန္ကုန္။",
              "commission_id": 1,
              "commission": 0,
              "user_id": 0,
              "old_credit": 0,
              "operator_id": 11,
              "credit": 0,
              "agent_commission": 0,
              "to_pay_credit": 0,
              "deposit_balance": 0
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetCreditAgentList" object:dict];
         }
     }];

}

- (void)postAgentCredit:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"access_token=%@&operator_id=%d&agent_id=%@&deposit=%@",token,operaterid, dict[@"agentid"], dict[@"deposit"]];
    
    NSString* postStrWithoutSpace = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@agent/deposit",baseip];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              "id": 606,
              "agentgroup_id": 0,
              "name": "\"Golden Bell Family  Travels & Tours\"",
              "phone": "၀၉၄၉၂၉၂၂၅၈၊ ၀၉၄၂၁၁၃၅၄၅၅",
              "address": "အမွတ္(၁၃၆/၁၃၈)၊ အေနာ္ရထာလမ္း၊ (၄၈)လမ္းႏွင့္ ဗုိလ္ျမတ္ထြန္းလမ္းၾကား၊ ဗိုလ္တေထာင္ျမိဳ႔နယ္၊ ရန္ကုန္။",
              "commission_id": 1,
              "commission": 0,
              "user_id": 0,
              "old_credit": 0,
              "operator_id": 11,
              "credit": 0,
              "agent_commission": 0,
              "to_pay_credit": 0,
              "deposit_balance": 0
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPostAgentCredit" object:dict];
         }
     }];

}

//http://192.168.1.116/trip?access_token=7WXzLWh6J207TWGeJYCDsevm6CPoTbS7iWcNPQpv&operator_id=11&group_by=trip

- (void)getTriplistWithFromto
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@trip?access_token=%@&operator_id=%d&group_by=trip",baseip,token,operaterid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*{
              "id": 49,
              "operator_id": 11,
              "from": 13,
              "to": 14,
              "operator": "ELITE",
              "from_city": "Yangon",
              "to_city": "Nay Pyi Taw",
              "class_id": 17,
              "classes": "Economy",
              "available_day": "Daily",
              "time": "06:00 AM",
              "price": 7200,
              "foreign_price": null
              }*/
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetTirpListCommission" object:dict];
         }
     }];

}

- (void)postAgentCommission:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"access_token=%@&agent_id=%@&trip_id=%@&commission_id=%@&commission=%@",token, dict[@"agentid"], dict[@"tripid"], dict[@"commid"], dict[@"comm"]];
    
    NSString* postStrWithoutSpace = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@operator/agentcommissio",baseip];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPostAgentComm" object:dict];
         }
     }];

}

- (void)postPrepaid:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"access_token=%@&operator_id=%d&agent_id=%@&deposit=%@",token,operaterid, dict[@"agentid"], dict[@"deposit"]];
    
    NSString* postStrWithoutSpace = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@agent/deposit",baseip];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPostPrepaid" object:dict];
         }
     }];
}

- (void)getCommission:(int)agentid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@operator/agentcommission? access_token=%@& agent_id=%d",baseip,token,agentid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*
              */
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetComm" object:dict];
         }
     }];

}

- (void)getPaymentHistory:(int)agentid
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@agents/credits/payment? access_token=%@&agent_id=%d&operator_id=%d",baseip,token,agentid,operaterid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*
              {
              "id": 130,
              "agent_id": 606,
              "operator_id": 11,
              "deposit_date": "2014-10-17",
              "deposit": 500,
              "total_ticket_amt": 0,
              "payment": 0,
              "pay_date": "0000-00-00",
              "balance": 500,
              "debit": 0,
              "agent": "\"Golden Bell Family  Travels & Tours\""
              }
              */
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetPaymentHistory" object:dict];
         }
     }];
}

- (void)getCreditList:(NSDictionary*)dict
{
    //http://192.168.1.116/agents/credits?agent_id=608&access_token=uaQMijJwSa0FkKAYLd8b1p2GbSBv5CgvADFPhpYk&operator_id=11&start_date=2014-09-29&end_date=2014-10-24&from=13&to=14&time=06:00 AM
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@agents/credits?agent_id=%@&access_token=%@&operator_id=%d&start_date=%@&end_date=%@&from=%@&to=%@&time=%@",baseip,dict[@"agentid"],token,operaterid,dict[@"startdate"], dict[@"enddate"], dict[@"from"], dict[@"to"], dict[@"time"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSArray *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             /*
              {
              "id": "50000001",
              "orderdate": "2014-10-24",
              "agent_id": 608,
              "operator_id": 11,
              "customer": "saw",
              "phone": "0896523",
              "operator": "ELITE",
              "agent": "-",
              "agent_commission": 1400,
              "commission": 700,
              "commission_type": "trip",
              "trip": "Yangon-Nay Pyi Taw",
              "total_ticket": 4,
              "price": 7200,
              "amount": 28800,
              "grand_total": 27400,
              "saleitems": [
              {
              "id": 403,
              "order_id": "40000001",
              "ticket_no": "12345667",
              "seat_no": "2",
              "nrc_no": "1/MaAhaPa(N) 12345",
              "name": "saw",
              "phone": "",
              "busoccurance_id": 21,
              "operator": 11,
              "price": 7200
              },
              */
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGetCreditList" object:dict];
         }
     }];

}

- (void)postChangeBusGate:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"access_token=%@&operator_id=%d&agent_id=%@&order_id=%@",token,operaterid, dict[@"agentid"], dict[@"orderid"]];
    
    NSString* postStrWithoutSpace = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@updateorder",baseip];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPostChangeBusGate" object:dict];
         }
     }];

}

- (void)postDeleteOrder:(NSString*)orderid
{
    //
    
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"access_token=%@&operator_id=%d&order_id=%@",token,operaterid, orderid];
    
    NSString* postStrWithoutSpace = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@deleteorder",baseip];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPostDeleteOrder" object:dict];
         }
     }];

}

- (void)postPayment:(NSDictionary*)dict
{
    NSString* baseip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    int operaterid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"access_token=%@&operator_id=%d&order_id=%@&agent_id=%@&payment_amount=%@",token,operaterid, dict[@"orderid"], dict[@"agentid"], dict[@"payamt"]];
    
    NSString* postStrWithoutSpace = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [NSString stringWithFormat:@"%@agents/credits/payment",baseip];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPBody:[postStrWithoutSpace dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPostPayment" object:dict];
         }
     }];

}



@end
