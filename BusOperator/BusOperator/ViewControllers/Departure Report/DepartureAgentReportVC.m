//
//  DepartureAgentReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/25/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DepartureAgentReportVC.h"
#import "TripReportCell.h"
#import "TripReportBySeatNoVC.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "DepartureSeatReportVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "City.h"
#import "Reachability.h"

@interface DepartureAgentReportVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tvReportWithBusNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTripTime;

@property (strong, nonatomic) IBOutlet UIView *bkgInfoView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleBusno;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalSale;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleTrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTime;


@end

@implementation DepartureAgentReportVC

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
    
    self.title = @"Agent Departure Report";

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoReportBySeat:) name:@"gotoReportBySeat" object:nil];
    
    _lblTitleBusno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleBusno.text = @"Agent";
    
    _lblTitleTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSeat.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း";
    
    _lblTripName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishgetDepartureSeatReport:) name:@"finishgetDepartureSeatReport" object:nil];
    
    _lblTitleDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleDate.text = @"ေရာင္းသည့္ေန႔:";
    
    _lblTitleTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTrip.text = @"ခရီးစဥ္ :";
    
    _lblTitleTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTime.text = @"ကားထြက္ခ်ိန္ :";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.reachable) {
        City* fromCity = _dataToPass[@"fromid"];
        City* toCity = _dataToPass[@"toid"];
        _lblTripName.text = [NSString stringWithFormat:@"%@ - %@",fromCity.name,toCity.name];
        _lblTripDate.text = _dataToPass[@"date"];
        _lblTripTime.text = _dataToPass[@"time"];
        
        long totalAmt = 0;
        for (NSDictionary* dict in _dataFiller) {
            totalAmt += [dict[@"total_amount"] longValue];
        }
        _lblTotal.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        NSDictionary* dict1 = @{@"agent": @"City Mart", @"sold_tickets":@"5/10", @"total_amount":@"10000"};
        NSDictionary* dict2 = @{@"agent": @"Agent 1", @"sold_tickets":@"5/10", @"total_amount":@"10000"};
        NSDictionary* dict3 = @{@"agent": @"Agent 2", @"sold_tickets":@"5/10", @"total_amount":@"10000"};
        
        _dataFiller = @[dict1, dict2, dict3];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishgetDepartureSeatReport:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    DepartureSeatReportVC* tripvc = (DepartureSeatReportVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureSeatReportVC"];
    tripvc.dataFiller = [tempArr copy];
    NSDictionary* dict = @{@"tripName": _lblTripName.text, @"tripDate": _lblTripDate.text, @"tripTime": _lblTripTime.text, @"busno": _dataToPass[@"busno"]};
    tripvc.dataToPass = [dict copy];

    [self.navigationController pushViewController:tripvc animated:YES];
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

- (void)myAction:(id)sender event:(id)event
{
    if (self.reachable) {
        UIButton* btn = (UIButton*)sender;
        NSDictionary* dict = _dataFiller[btn.tag];
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getDepartureSeatReport:dict[@"bus_id"] withAgentid:dict[@"agent_id"]];
    }
    else {
        DepartureSeatReportVC* tripvc = (DepartureSeatReportVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureSeatReportVC"];
        [self.navigationController pushViewController:tripvc animated:YES];

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
    NSString* cellid = @"tripReportByBusCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    /*
     {
     "bus_id": "113",
     "agent_id": "0",
     "agent": "-",
     "sold_tickets": 5,
     "total_amount": 75000,
     "total_seats": 33
     }*/
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = dict[@"agent"];
    cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"sold_tickets"]];
    cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amount"]];
    
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
