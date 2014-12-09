//
//  DailySaleReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/18/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DailySaleReportVC.h"
#import "JDStatusBarNotification.h"
#import "TripReportCell.h"
#import "DepartureReportWithBusNoVC.h"
#import "DepartureReportWithTimeVC.h"
#import "DataFetcher.h"
#import "Reachability.h"
#import "TransitionDelegate.h"
#import "DepartureReportWithSeatNoVC.h"

@interface DailySaleReportVC ()

@property (strong, nonatomic) NSArray* upDataFiller;
@property (strong, nonatomic) NSArray* downDataFiller;
@property (assign, nonatomic) long totalAmt;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) TransitionDelegate* transitionController;
@property (strong, nonatomic) UIPopoverController* mypopoverController;
@property (strong, nonatomic) NSString* strdate;

@property (weak, nonatomic) IBOutlet UILabel *lblTodayTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTodaySale;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseDate;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) IBOutlet UITableView *tbTime;
@property (strong, nonatomic) IBOutlet UITableView *tbDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblSeatCount;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDownSeatCount;
@property (strong, nonatomic) IBOutlet UILabel *lblDownTotalAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblWholeAmt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uptbHeightConstrait;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *downtbHeightConstrait;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTrip;
@property (weak, nonatomic) IBOutlet UILabel *lbldownTrip;

- (IBAction)Search:(id)sender;

@end

@implementation DailySaleReportVC
@synthesize transitionController;

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
    
    transitionController = [[TransitionDelegate alloc] init];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString* todaydate = [dateFormat stringFromDate:[NSDate date]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    _strdate = [dateFormat stringFromDate:[NSDate date]];
    
    _lblChooseDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblChooseDate.text = @"ေန ့ရက္ :";
    
    _btnDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:16.0f];
    [_btnDate setTitle:todaydate forState:UIControlStateNormal];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:16.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _lblTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTime.text = @"ကားထြက္ခ်ိန္";
    
    _lbldownTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbldownTrip.text = @"ခရီးစဥ္";
    
    _lblTitleTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTrip.text = @"ခရီးစဥ္";
    
    _lblSeatCount.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSeatCount.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalAmt.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotal.text = @"စုုစုုေပါင္း";
    
    _lblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDate.text = @"ကားထြက္မည့္ ေန ့ရက္";
    
    _lblDownSeatCount.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDownSeatCount.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblDownTotalAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDownTotalAmt.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTodayTime.font = [UIFont fontWithName:@"Zawgyi-One" size:16.0f];
    _lblTodayTime.text = @"ယေန ့ထြက္ခြာမည့္အခ်ိန္မ်ား";
    
    _lblTodaySale.font = [UIFont fontWithName:@"Zawgyi-One" size:16.0f];
    _lblTodaySale.text = @"ၾကိဳေရာင္း";

    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"alldailyreportvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Daily Departure Report
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllDailyDepartureReportByTime:) name:@"finishAllDailyDepartureReportByTime" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllDailyDepartureReportByBus:) name:@"finishAllDailyDepartureReportByBus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllAdvanceReportByDate:) name:@"finishAllAdvanceReportByDate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllAdvacneReportByTime:) name:@"finishAllAdvacneReportByTime" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetDailyReportBySeat:) name:@"finishGetDailyReportBySeat" object:nil];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        todaydate = [dateFormat stringFromDate:[NSDate date]];        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getDailyReportByTime:todaydate]; // [NSDate date] // today date
        [fetcher getAdvanceReportByDate:todaydate];

    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        NSDictionary* dict1 = @{@"time": @"10:00 AM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict2 = @{@"time": @"1:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict3 = @{@"time": @"4:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict7 = @{@"time": @"10:00 AM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict8 = @{@"time": @"1:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict9 = @{@"time": @"4:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict10 = @{@"time": @"10:00 AM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict11 = @{@"time": @"1:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        NSDictionary* dict12 = @{@"time": @"4:30 PM", @"sold_seat":@"15", @"sold_amount":@"30000"};
        
        _upDataFiller = @[dict1, dict2, dict3, dict10, dict11, dict12, dict7, dict8, dict9];
        
        NSDictionary* dict4 = @{@"departure_date": @"22-6-14", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
        NSDictionary* dict5 = @{@"departure_date": @"23-5-14", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
        NSDictionary* dict6 = @{@"departure_date": @"25-5-14", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
        
        _downDataFiller = @[dict4, dict5, dict6];

        _lblWholeAmt.text = @"360000 Ks";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateDailyreport:) name:@"didSelectDateDailyreport" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _totalAmt = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _mypopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}



- (void)didSelectDateDailyreport:(NSNotification*)noti
{
    _strdate = (NSString*)noti.object;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate* tdate = [df dateFromString:_strdate];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* newstr = [df stringFromDate:tdate];
    [_btnDate setTitle:newstr forState:UIControlStateNormal];
    
    [_mypopoverController dismissPopoverAnimated:YES];
}

- (void)resizeUpTableView
{
    NSInteger datacount = _upDataFiller.count;
    float tbHeight = 59 * datacount;
    
    _uptbHeightConstrait.constant = tbHeight;
}

- (void)resizeDownTableView
{
    NSInteger datacount = _downDataFiller.count;
    float tbHeight = 59 * datacount;
    
    _downtbHeightConstrait.constant = tbHeight;
}

- (void)finishAllDailyDepartureReportByTime:(NSNotification*)notification
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
    _upDataFiller = [resultArr copy];
    
    [self resizeUpTableView];
    
    [_tbTime reloadData];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _upDataFiller) {
        totalAmt += [dict[@"sold_amount"] longValue];
    }
    _totalAmt += totalAmt;
    _lblWholeAmt.text = [NSString stringWithFormat:@"%ld Ks",_totalAmt];
    
}

- (void)finishAllDailyDepartureReportByBus:(NSNotification*)notification
{
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
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)notification.object;
    DepartureReportWithBusNoVC* tripvc = (DepartureReportWithBusNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithBusNoVC"];
    tripvc.dataFiller = [resultArr copy];
    [self.navigationController pushViewController:tripvc animated:YES];
    
}

- (void)finishAllAdvanceReportByDate:(NSNotification*)noti
{
    /*
     {
     "purchased_total_seat": 8,
     "total_amout": 120000,
     "departure_date": "2014-06-19",
     "total_seat": 27
     }
     */
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    _downDataFiller = [resultArr copy];
    
    [self resizeDownTableView];
    
    [_tbDate reloadData];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _downDataFiller) {
        totalAmt += [dict[@"total_amout"] longValue];
    }
    _totalAmt += totalAmt;
    _lblWholeAmt.text = [NSString stringWithFormat:@"%ld Ks",_totalAmt];
    
}

- (void)finishAllAdvacneReportByTime:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
//    DepartureReportWithTimeVC* seatvc = (DepartureReportWithTimeVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithTimeVC"];
//    seatvc.previousvc = @"Advance";
//    seatvc.dataFiller = [resultArr copy];
//    [self.navigationController pushViewController:seatvc animated:YES];
    
    DepartureReportWithBusNoVC* nextvc = (DepartureReportWithBusNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithBusNoVC"];
    nextvc.dataFiller = [resultArr copy];
    [self.navigationController pushViewController:nextvc animated:YES];
}


- (void)finishGetDailyReportBySeat:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)notification.object;
    
    DepartureReportWithSeatNoVC* tripvc = (DepartureReportWithSeatNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithSeatNoVC"];
    tripvc.dataFiller = [resultArr copy];
    [self.navigationController pushViewController:tripvc animated:YES];
    
}


- (void)myAction:(id)sender event:(id)event
{
    if (self.reachable) {
        UIButton* btn = (UIButton*)sender;
        NSDictionary* dict = _upDataFiller[btn.tag];
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

- (void)
:(NSNotification*)notification
{
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
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)notification.object;
    DepartureReportWithBusNoVC* tripvc = (DepartureReportWithBusNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithBusNoVC"];
    tripvc.dataFiller = [resultArr copy];
    [self.navigationController pushViewController:tripvc animated:YES];
    
}
- (void)downCellAction:(id)sender event:(id)event
{
    if (self.reachable) {
        UIButton* btn = (UIButton*)sender;
        NSDictionary* dict = _downDataFiller[btn.tag];
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAdvanceReportByTime:dict[@"departure_date"] withDate:_strdate];
    }
    else {
        DepartureReportWithTimeVC* seatvc = (DepartureReportWithTimeVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithTimeVC"];
        seatvc.previousvc = @"Advance";
        [self.navigationController pushViewController:seatvc animated:YES];
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
    NSInteger count = 0;
    if (tableView == _tbTime) {
        count = _upDataFiller.count;
    }
    else count = _downDataFiller.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    if (tableView == _tbTime) {
        NSString* cellid = @"upCell";
        TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        cell.cellLblTextExtra.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        
        NSDictionary* dict = _upDataFiller[indexPath.row];
        
        cell.cellLblDate.text = [NSString stringWithFormat:@"%@(%@)", dict[@"time"],dict[@"classes"]];
        cell.cellLblTextExtra.text = [NSString stringWithFormat:@"%@-%@",dict[@"from"],dict[@"to"]];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"sold_seat"]];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"sold_amount"]];
        
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
    else {
        NSString* cellid = @"downCell";
        TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        NSDictionary* dict = _downDataFiller[indexPath.row];
        
        /*
         {
         "purchased_total_seat": 8,
         "total_amout": 120000,
         "departure_date": "2014-06-19",
         "total_seat": 27
         }
         */
        
        cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        cell.cellLblTextExtra.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* tdate = [df dateFromString:dict[@"departure_date"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString* newstr = [df stringFromDate:tdate];
        cell.cellLblDate.text = newstr;
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"purchased_total_seat"]];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];
        cell.cellLblTextExtra.text = [NSString stringWithFormat:@"%@-%@",dict[@"from"],dict[@"to"]];
        
        UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
        btnCell.backgroundColor = [UIColor clearColor];
        [btnCell setTitle:@"View Detail" forState:UIControlStateNormal];
        [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCell addTarget:self action:@selector(downCellAction:event:) forControlEvents:UIControlEventTouchUpInside];
        
        btnCell.tag = indexPath.row;
        [cell.cellBtnBkgView addSubview:btnCell];
        
        return cell;

    }
}



- (IBAction)Search:(id)sender {
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getDailyReportByTime:_strdate]; // [NSDate date] // today date
    [fetcher getAdvanceReportByDate:_strdate];
}
@end
