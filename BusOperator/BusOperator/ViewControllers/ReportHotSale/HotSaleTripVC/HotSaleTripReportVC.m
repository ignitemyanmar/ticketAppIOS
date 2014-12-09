//
//  HotSaleTripReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HotSaleTripReportVC.h"
#import "SelectAgentGroupVC.h"
#import "DataFetcher.h"
#import "TripReportCell.h"
#import "Reachability.h"
#import "HotSaleTripByTimeVC.h"
#import "JDStatusBarNotification.h"

@interface HotSaleTripReportVC ()

@property (assign, nonatomic) BOOL isFromDate;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (assign, nonatomic) int selectedagentid;
@property (strong, nonatomic) NSArray* agentlist;

@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnAgent;
@property (weak, nonatomic) IBOutlet UILabel *lbltitleagent;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSale;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbpopulartrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;

- (IBAction)SelectFromDate:(id)sender;
- (IBAction)SelectToDate:(id)sender;
- (IBAction)SearchPopularTrip:(id)sender;

@end

@implementation HotSaleTripReportVC

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    _lblTitleDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleDate.text = @"ခရီးစဥ္";
    
    _lblTitleTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSeat.text = @"စုုစုုေပါင္း ခံုု";
    
    _lblTitleTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSale.text = @"စုုစုုေပါင္း ေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း";
    
    _lbltitleagent.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitleagent.text = @"ခရီးသြား၀န္ေဆာင္မႈလုုပ္ငန္း :";
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishdownloadagentHotSaleTrip:) name:@"finishdownloadagentHotSaleTrip" object:nil];
    
    DataFetcher* datafetcher = [DataFetcher new];
    [datafetcher getReportAgentListByOpid:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateHotSaleTrip:) name:@"didSelectDateHotSaleTrip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAgentHotSaleTrip:) name:@"didSelectAgentHotSaleTrip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPopularTrips:) name:@"finishGetPopularTrips" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPopularTripTime:) name:@"finishGetPopularTripTime" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HotSaleTripReport" forKey:@"currentvc"];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetPopularTripTime:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* temparr = (NSArray*)notification.object;
    
    HotSaleTripByTimeVC* nexvc = (HotSaleTripByTimeVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"HotSaleTripByTimeVC"];
    nexvc.dataFiller = [temparr copy];
    [self.navigationController pushViewController:nexvc animated:YES];
}

- (void)finishdownloadagentHotSaleTrip:(NSNotification*)notification
{
//    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)notification.object;
    NSMutableArray* tempmuarr = [tempArr mutableCopy];
    [tempmuarr insertObject:@{@"id": @"0", @"name": @"Select All"} atIndex:0];
    _agentlist = [tempmuarr copy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
//    if (self.reachable) {
        if ([segue.identifier isEqualToString:@"agentpopover"]) {
            SelectAgentGroupVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.isAgentListShowing = YES;
            triplistvc.tripList = [_agentlist copy];
            
        }
//    }
}

- (void)finishGetPopularTrips:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* temparr = (NSArray*)notification.object;
    _dataFiller = [temparr copy];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amount"] longLongValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    
    [_tbpopulartrip reloadData];
}

- (void)didSelectDateHotSaleTrip:(NSNotification*)notification
{
    NSString* strdate = (NSString*)notification.object;
    if (_isFromDate) [_btnFromDate setTitle:strdate forState:UIControlStateNormal];
    else [_btnToDate setTitle:strdate forState:UIControlStateNormal];
    
    [_myPopoverController dismissPopoverAnimated:YES];
    
}

- (void)didSelectAgentHotSaleTrip:(NSNotification*)notification
{
    NSDictionary* dict = (NSDictionary*)notification.object;
    [_btnAgent setTitle:dict[@"name"] forState:UIControlStateNormal];
    _selectedagentid = [dict[@"id"] intValue];
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)SelectFromDate:(id)sender {
    _isFromDate = YES;
}

- (IBAction)SelectToDate:(id)sender {
    _isFromDate = NO;
}

- (IBAction)SearchPopularTrip:(id)sender {
    if (![_btnFromDate.titleLabel.text isEqualToString:@"From Date"] && ![_btnToDate.titleLabel.text isEqualToString:@"To Date"] && ![_btnAgent.titleLabel.text isEqualToString:@"Agent"]) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:3.0f];
        DataFetcher* fetcher = [DataFetcher new];
        NSDictionary* dict = @{@"startdate": _btnFromDate.titleLabel.text, @"enddate": _btnToDate.titleLabel.text, @"agentid": @(_selectedagentid)};
        [fetcher getPopularTripReport:dict];
    }
}

- (void)viewDetail:(id)sender
{
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:3.0f];
    UIButton* btn = (UIButton*)sender;
    NSDictionary* dict = _dataFiller[btn.tag];
    
    NSDictionary* tempdict = @{@"startdate": _btnFromDate.titleLabel.text, @"enddate": _btnToDate.titleLabel.text, @"from": dict[@"from"], @"to": dict[@"to"], @"agentid": @(_selectedagentid)};
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getPopularTripTimeReport:tempdict];
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
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"trip"];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@/%@",dict[@"sold_total_seat"],dict[@"total_seat"]] ;
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amount"]];
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
