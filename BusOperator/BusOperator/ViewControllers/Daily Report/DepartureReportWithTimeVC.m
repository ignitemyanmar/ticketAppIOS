//
//  DepartureReportWithTimeVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DepartureReportWithTimeVC.h"
#import "TripReportCell.h"
#import "JDStatusBarNotification.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "DataFetcher.h"
#import "Reachability.h"
#import "DepartureReportWithSeatNoVC.h"

@interface DepartureReportWithTimeVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblSeatCount;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (strong, nonatomic) IBOutlet UITableView *tbReportByTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblAllTotalAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTrip;

@end

@implementation DepartureReportWithTimeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    self.title = @"Daily Departure Time Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    _lblTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTime.text = @"ကားထြက္ခ်ိန္";
    
    _lblSeatCount.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSeatCount.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalAmt.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotal.text = @"စုုစုုေပါင္း";
    
//    _lblTitleTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
//    _lblTitleTrip.text = @"ခရီးစဥ္";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"DepartureReportvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetDailyReportByTime:) name:@"finishGetDailyReportByTime" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetDailyReportBySeat:) name:@"finishGetDailyReportBySeat" object:nil];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* todaydate = [dateFormat stringFromDate:[NSDate date]];
    
    if (![_previousvc isEqualToString:@"Advance"]) {
    
        if (self.reachable) {
            [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
            DataFetcher* fetcher = [DataFetcher new];
            [fetcher getDailyReportByTime:todaydate]; // [NSDate date] // today date

        }
        else {
            [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
            NSDictionary* dict1 = @{@"time": @"10:00 AM", @"sold_seat":@"15", @"sold_amount":@"30000"};
            NSDictionary* dict2 = @{@"time": @"1:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
            NSDictionary* dict3 = @{@"time": @"4:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
            
            _dataFiller = @[dict1, dict2, dict3];
            
            _lblAllTotalAmt.text = @"90000 Ks";

        }
        
    }
    else {
    
        if (!self.reachable) {
            [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
            NSDictionary* dict1 = @{@"time": @"10:00 AM", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
            NSDictionary* dict2 = @{@"time": @"1:30 PM", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
            NSDictionary* dict3 = @{@"time": @"4:30 PM", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
            
            _dataFiller = @[dict1, dict2, dict3];
            
            _lblAllTotalAmt.text = @"90000 Ks";
            
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetDailyReportByTime:(NSNotification*)notification
{
    /*
     "from": "Yangon",
     "to": "Mandalay",
     "time": "10:00 AM",
     "sold_seat": 2,
     "total_seat": 27,
     "price": "15000",
     "sold_amount": 30000
     */
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)notification.object;
    _dataFiller = [resultArr copy];
    
    [_tbReportByTime reloadData];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"sold_amount"] longValue];
    }
    _lblAllTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    
}

//- (void)finishGetDailyReportByBus:(NSNotification*)notification
//{
//    /*
//     {
//     "bus_id": "3",
//     "bus_no": "YGN-9891",
//     "from": "Yangon",
//     "to": "Mandalay",
//     "class": "Special",
//     "time": "10:00 AM",
//     "sold_seat": 2,
//     "total_seat": 27,
//     "price": "15000",
//     "sold_amount": 30000
//     }
//     */
////    [self JDStatusBarHidden:YES status:@"" duration:0];
////    NSArray* resultArr = (NSArray*)notification.object;
////    DepartureReportWithBusNoVC* tripvc = (DepartureReportWithBusNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithBusNoVC"];
////    tripvc.dataFiller = [resultArr copy];
////    [self.navigationController pushViewController:tripvc animated:YES];
//    
//}

- (void)finishGetDailyReportBySeat:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)notification.object;
    
//    DepartureReportWithSeatNoVC* tripvc = (DepartureReportWithSeatNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithSeatNoVC"];
//    tripvc.dataFiller = [resultArr copy];
//    [self.navigationController pushViewController:tripvc animated:YES];
    
}


- (void)myAction:(id)sender event:(id)event
{
    if (self.reachable) {
        UIButton* btn = (UIButton*)sender;
        NSDictionary* dict = _dataFiller[btn.tag];
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getDailyReportBySeat:dict[@"bus_id"]];
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        DepartureReportWithSeatNoVC* tripvc = (DepartureReportWithSeatNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithSeatNoVC"];
        [self.navigationController pushViewController:tripvc animated:YES];
    }
    
    
}

- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}


#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"departureTimeCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    
    if ([_previousvc isEqualToString:@"Advance"]) {
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
        
        cell.cellLblDate.text = dict[@"time"];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"purchased_total_seat"]];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];

    }
    else {
        cell.cellLblDate.text = dict[@"time"];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"sold_seat"]];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"sold_amount"]];
//        cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@-%@",dict[@"from"],dict[@"to"]];
    }
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"View Detail" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(myAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    return cell;
}




@end
