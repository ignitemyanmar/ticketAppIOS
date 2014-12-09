//
//  DepartureBusReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/25/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DepartureBusReportVC.h"
#import "TripListVC.h"
#import "TripTimeListVC.h"
#import "DataFetcher.h"
#import "City.h"
#import "JDStatusBarNotification.h"
#import "TripReportCell.h"
#import "DepartureAgentReportVC.h"
#import "DataFetcher.h"
#import "Reachability.h"

@interface DepartureBusReportVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* strpopoverview;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (strong, nonatomic) NSArray* fromCityList;
@property (strong, nonatomic) NSArray* toCityList;
@property (strong, nonatomic) NSArray* timeStrArr;
@property (strong, nonatomic) City* currentFromCity;
@property (strong, nonatomic) City* currentToCity;
@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) City* fromCity;
@property (strong, nonatomic) City* toCity;
@property (strong, nonatomic) NSString* strDate;
@property (strong, nonatomic) NSString* strTime;
@property (strong, nonatomic) NSString* strBusno;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UIView *bkgBtnView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnToDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTime;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) IBOutlet UILabel *lblBusno;
@property (strong, nonatomic) IBOutlet UILabel *lblDepartureDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalSale;
@property (strong, nonatomic) IBOutlet UITableView *tbBusReport;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblBusTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBusDate;


- (IBAction)SearchSeatPlan:(id)sender;
- (IBAction)onFromCityClick:(id)sender;
- (IBAction)onToCityClick:(id)sender;

@end

@implementation DepartureBusReportVC

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
    
    self.title = @"Bus Departure Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (!self.reachable) {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"departurereport" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetCityDepartureReport:) name:@"finishGetCityDepartureReport" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetTimeDepartureReport:) name:@"finishGetTimeDepartureReport" object:nil];
    
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCitiesWithOpid];
    [fetcher getTimeWithOpid];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTripDepartureReport:) name:@"selectTripDepartureReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTimeDepartureReport:) name:@"selectTimeDepartureReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDateDepartureReport:) name:@"selectDateDepartureReport" object:nil];
    
    _btnSelectTrip.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTrip setTitle:@"အစ ခရီး" forState:UIControlStateNormal];
    
    _btnSelectTime.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTime setTitle:@"ကားထြက္ခ်ိန္" forState:UIControlStateNormal];
    
    _btnFromDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnFromDate setTitle:@"အဆံုုး ခရီး" forState:UIControlStateNormal];
    
    _btnToDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnToDate setTitle:@"ထြက္ခြာမည့္ေန ့ရက္" forState:UIControlStateNormal];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _lblBusno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusno.text = @"ကားအမ်ိဴးအစား";
    
    _lblBusTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusTime.text = @"ကားထြက္ခ်ိန္";
    
    _lblBusDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusDate.text = @"ကားထြက္မည့္ေန ့";
    
    _lblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSeat.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotal.text = @"စုုစုုေပါင္း";
    
//    _lblDepartureDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
//    _lblDepartureDate.text = @"ကားထြက္မည့္ ေန ့ရက္";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishgetDepartureBusReport:) name:@"finishgetDepartureBusReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishgetDepartureAgentReport:) name:@"finishgetDepartureAgentReport" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NOTIFICATION METHODS
- (void)finishGetCityDepartureReport:(NSNotification*)noti
{
    NSDictionary* tempDict = (NSDictionary*)noti.object;
    NSArray* fromArr = tempDict[@"fromCity"];
    _fromCityList = [fromArr copy];
    NSArray* toArr = tempDict[@"toCity"];
    _toCityList = [toArr copy];
    
}

- (void)finishGetTimeDepartureReport:(NSNotification*)noti
{
    _timeStrArr = (NSArray*)noti.object;
}

- (void)selectTripDepartureReport:(NSNotification*)notification
{
    if (self.reachable) {
        City* city = (City*)notification.object;
        if ([_strpopoverview isEqualToString:@"FromCity"]) {
            [_btnSelectTrip setTitle:city.name forState:UIControlStateNormal];
            _currentFromCity = city;
        }
        else {
            [_btnFromDate setTitle:city.name forState:UIControlStateNormal];
            _currentToCity = city;
        }
    }
    else {
        NSString* str = (NSString*)notification.object;
        if ([_strpopoverview isEqualToString:@"FromCity"]) {
            [_btnSelectTrip setTitle:str forState:UIControlStateNormal];
        }
        else {
            [_btnFromDate setTitle:str forState:UIControlStateNormal];
        }
    }
    
    [_myPopoverController dismissPopoverAnimated:YES];
    
}

- (void)selectTimeDepartureReport:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectTime setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)selectDateDepartureReport:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnToDate setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)finishgetDepartureBusReport:(NSNotification*)noti
{
    /*
     {
     "id": "113",
     "bus_no": "YGN-9898",
     "sold_seats": 5,
     "total_seats": 33,
     "total_amount": 75000
     }*/
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    
    [_tbBusReport reloadData];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amout"] longValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];

}

- (void)finishgetDepartureAgentReport:(NSNotification*)noti
{
    /*
     {
     "bus_id": "113",
     "agent_id": "0",
     "agent": "-",
     "sold_tickets": 5,
     "total_amount": 75000,
     "total_seats": 33
     }*/
    
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    DepartureAgentReportVC* destvc = (DepartureAgentReportVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"DepartureAgentReportVC"];
    NSDictionary* dict = @{@"fromid": _fromCity,
                           @"toid": _toCity,
                           @"date": _strDate,
                           @"time": _strTime,
                           @"busno": _strBusno};
    destvc.dataFiller = [tempArr copy];
    destvc.dataToPass = [dict copy];
    [self.navigationController pushViewController:destvc animated:YES];

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



#pragma mark - CLASS METHODS
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    if (self.reachable) {
        if ([segue.identifier isEqualToString:@"fromCitySegue"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_fromCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"toCitySegue"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_toCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"timeSegue"])
        {
            TripTimeListVC* triptimelist = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triptimelist.tripList = [_timeStrArr mutableCopy];
        }
    }
    
}


- (IBAction)SearchSeatPlan:(id)sender {
    
    if (self.reachable) {
        _fromCity = _currentFromCity;
        _toCity = _currentToCity;
        _strDate = _btnToDate.titleLabel.text;
        _strTime = _btnSelectTime.titleLabel.text;
        
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        NSDictionary* dict = @{@"date": _btnToDate.titleLabel.text,
                               @"time": _btnSelectTime.titleLabel.text,
                               @"from": _currentFromCity.id,
                               @"to": _currentToCity.id};
        
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getDepartureBusReport:dict];

    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        NSDictionary* dict1 = @{@"bus_no": @"AA/12345", @"sold_seats":@"5/10", @"total_amount":@"10000"};
        NSDictionary* dict2 = @{@"bus_no": @"BB/12345", @"sold_seats":@"5/10", @"total_amount":@"10000"};
        NSDictionary* dict3 = @{@"bus_no": @"1AA/67890", @"sold_seats":@"5/10", @"total_amount":@"10000"};
        
        _dataFiller = @[dict1, dict2, dict3];
        
        [_tbBusReport reloadData];
        
        _lblTotalAmt.text = @"30000 Ks";
    }

}

- (IBAction)onFromCityClick:(id)sender {
    _strpopoverview = @"FromCity";
}

- (IBAction)onToCityClick:(id)sender {
    _strpopoverview = @"toCity";
}

- (void)viewDetail:(id)sender event:(id)event
{
//    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
//    UIButton* btn = (UIButton*)sender;
//    NSDictionary* myDict = _dataFiller[btn.tag];
//    _selectedDepartureDate = myDict[@"departure_date"];
//    City* fromCity = _dataToPass[@"fromid"];
//    City* toCity = _dataToPass[@"toid"];
//    DataFetcher* fetcher = [DataFetcher new];
//    [fetcher getReportAgentSeatNoWithOpid:1 withFromCity:fromCity.id withToCity:toCity.id withDate:_dataToPass[@"date"] withTime:myDict[@"time"] withBusNo:myDict[@"bus_id"]];
    
    UIButton* btn = (UIButton*)sender;
    NSDictionary* myDict = _dataFiller[btn.tag];
    _strBusno = myDict[@"bus_no"];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getDepartureAgentReport:myDict[@"bus_id"]];
    }
    else {
        DepartureAgentReportVC* destvc = (DepartureAgentReportVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"DepartureAgentReportVC"];
        [self.navigationController pushViewController:destvc animated:YES];

    }
}


#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"busdepartureCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    /*
     {
     "id": "113",
     "bus_no": "YGN-9898",
     "sold_seats": 5,
     "total_seats": 33,
     "total_amount": 75000
     }*/
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTransactionNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = dict[@"class"];
    cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@/%@",dict[@"purchased_total_seat"], dict[@"total_seat"]];
    cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate* tdate = [df dateFromString:dict[@"departure_date"]];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* newstr = [df stringFromDate:tdate];

    cell.cellLblUnitPrice.text = newstr;
    cell.cellLblTransactionNo.text = dict[@"time"];
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"View Detail" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(viewDetail:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    return cell;
}



@end
