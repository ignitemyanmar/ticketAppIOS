//
//  HotSaleAgentReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HotSaleAgentReportVC.h"
#import "TripReportCell.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "HotSaleAgentTripReportVC.h"
#import "UIColor+Utilities.h"

@interface HotSaleAgentReportVC ()

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (assign, nonatomic) BOOL isFromDate;
@property (assign, nonatomic) int selectedagentid;

@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblagentname;
@property (weak, nonatomic) IBOutlet UILabel *lbltotalSeat;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (weak, nonatomic) IBOutlet UITableView *tbPopularAgent;

- (IBAction)SelectFromDate:(id)sender;
- (IBAction)SelectToDate:(id)sender;
- (IBAction)Search:(id)sender;


@end

@implementation HotSaleAgentReportVC

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
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];

    
    _lblagentname.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblagentname.text = @"နာမည္";
    
    _lbltotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltotalSeat.text = @"စုုစုုေပါင္း ခံုု";
    
    _lblTotalPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalPrice.text = @"စုုစုုေပါင္း ေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း :";
    
    _lblTotalAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _btnFromDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _btnToDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPopularAgent:) name:@"finishGetPopularAgent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateHotSaleAgent:) name:@"didSelectDateHotSaleAgent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPopularTrips:) name:@"finishGetPopularTrips" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HotSaleAgent" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amount"] longLongValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (void)finishGetPopularTrips:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* temparr = (NSArray*)notification.object;

    
    HotSaleAgentTripReportVC* nexvc = (HotSaleAgentTripReportVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"HotSaleAgentTripReportVC"];
    nexvc.dataFiller = [temparr copy];
    nexvc.fromdate = _btnFromDate.titleLabel.text;
    nexvc.todate = _btnToDate.titleLabel.text;
    nexvc.agentid = _selectedagentid;
    [self.navigationController pushViewController:nexvc animated:YES];
}


- (void)finishGetPopularAgent:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempdict = (NSArray*)notification.object;
    _dataFiller = [tempdict copy];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amount"] longLongValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    
    [_tbPopularAgent reloadData];
}

- (void)didSelectDateHotSaleAgent:(NSNotification*)notification
{
    NSString* strdate = (NSString*)notification.object;
    if (_isFromDate) [_btnFromDate setTitle:strdate forState:UIControlStateNormal];
    else [_btnToDate setTitle:strdate forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)SelectFromDate:(id)sender {
    _isFromDate = YES;
}

- (IBAction)SelectToDate:(id)sender {
    _isFromDate = NO;
}

- (IBAction)Search:(id)sender {
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:3.0f];
        DataFetcher* fetcher = [DataFetcher new];
        NSDictionary* dict = @{@"startdate": _btnFromDate.titleLabel.text, @"enddate": _btnToDate.titleLabel.text};
        [fetcher getPopularAgentReport:dict];
    }
}

- (void)viewDetail:(id)sender
{
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:3.0f];
        UIButton* btn = (UIButton*)sender;
        NSDictionary* tempdict = _dataFiller[btn.tag];
        _selectedagentid = [tempdict[@"id"] intValue];
        NSDictionary* dict = @{@"startdate": _btnFromDate.titleLabel.text, @"enddate": _btnToDate.titleLabel.text, @"agentid": tempdict[@"id"]};
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getPopularTripReport:dict];
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
    NSString* cellid = @"tripReportCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTextExtra.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"name"];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"purchased_total_seat"]] ;
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amount"]];
        cell.cellLblTextExtra.text = dict[@"label_name"];
        NSString* colorcode = [NSString stringWithFormat:@"%@",dict[@"label_color"]];
        cell.cellBtnEditBkgView.backgroundColor = [UIColor colorFromRGBHexString:colorcode];
    }
    else {
        cell.cellLblDate.text = dict[@"date"];
        cell.cellLblTotalSeat.text = dict[@"totalSeat"];
        cell.cellLblTotalSales.text = dict[@"totalSale"];
    }
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"View Detail" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(viewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    return cell;
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

@end
