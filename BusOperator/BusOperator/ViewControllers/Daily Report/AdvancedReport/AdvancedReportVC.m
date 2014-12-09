//
//  AdvancedReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AdvancedReportVC.h"
#import "TripReportCell.h"
#import "JDStatusBarNotification.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "DepartureReportWithBusNoVC.h"
#import "DepartureReportWithTimeVC.h"
#import "DataFetcher.h"
#import "Reachability.h"

@interface AdvancedReportVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblSeatCount;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (strong, nonatomic) IBOutlet UITableView *tbReportByTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblAllTotalAmt;

@end

@implementation AdvancedReportVC

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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString* todaydate = [dateFormat stringFromDate:[NSDate date]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    self.title = @"Departure Date Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    _lblTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTime.text = @"ကားထြက္မည့္ ေန ့ရက္";
    
    _lblSeatCount.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSeatCount.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalAmt.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotal.text = @"စုုစုုေပါင္း";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAdvanceReportByDate:) name:@"finishAdvanceReportByDate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAdvacneReportByTime:) name:@"finishAdvacneReportByTime" object:nil];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAdvanceReportByDate:todaydate];
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        NSDictionary* dict1 = @{@"departure_date": @"22-6-14", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
        NSDictionary* dict2 = @{@"departure_date": @"23-5-14", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
        NSDictionary* dict3 = @{@"departure_date": @"25-5-14", @"purchased_total_seat":@"15", @"total_amout":@"30000"};
        
        _dataFiller = @[dict1, dict2, dict3];
        
        _lblAllTotalAmt.text = @"90000 Ks";

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishAdvanceReportByDate:(NSNotification*)noti
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
    _dataFiller = [resultArr copy];
    
    [_tbReportByTime reloadData];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amout"] longValue];
    }
    _lblAllTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];

}

- (void)finishAdvacneReportByTime:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    DepartureReportWithTimeVC* seatvc = (DepartureReportWithTimeVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartureReportWithTimeVC"];
    seatvc.previousvc = @"Advance";
    seatvc.dataFiller = [resultArr copy];
    [self.navigationController pushViewController:seatvc animated:YES];

}

- (void)myAction:(id)sender event:(id)event
{
    if (self.reachable) {
        UIButton* btn = (UIButton*)sender;
        NSDictionary* dict = _dataFiller[btn.tag];
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
//        [fetcher getAdvanceReportByTime:dict[@"departure_date"]];
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
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"departureTimeCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
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
    
    cell.cellLblDate.text = dict[@"departure_date"];
    cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"purchased_total_seat"]];
    cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];
    
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
