//
//  HotSaleTypeReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HotSaleTypeReportVC.h"
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"
#import "SelectAgentGroupVC.h"
#import "TripReportCell.h"

@interface HotSaleTypeReportVC () <XYPieChartDelegate, XYPieChartDataSource, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* slices;
@property (strong, nonatomic) NSArray* sliceColors;
@property (strong, nonatomic) NSArray* allSliceColors;
@property (assign, nonatomic) BOOL isFromDate;
@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (strong, nonatomic) NSArray* agentlist;
@property (assign, nonatomic) int selectedagentid;

@property (strong, nonatomic) NSArray* dataFiller;

@property (weak, nonatomic) IBOutlet XYPieChart *piechart;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnAgent;
@property (weak, nonatomic) IBOutlet UILabel *lbltitleagent;
@property (weak, nonatomic) IBOutlet UITableView *tbIndicator;

- (IBAction)SelectFromDate:(id)sender;
- (IBAction)SelectToDate:(id)sender;
- (IBAction)Search:(id)sender;

@end

@implementation HotSaleTypeReportVC

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
    
//    _slices = @[@(66), @(33)];
    
    _lbltitleagent.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitleagent.text = @"ခရီးသြား၀န္ေဆာင္မႈလုုပ္ငန္း :";
    
    [self.piechart setDelegate:self];
    [self.piechart setDataSource:self];
    [self.piechart setStartPieAngle:M_PI_2];
    [self.piechart setAnimationSpeed:1.0];
    [self.piechart setLabelFont:[UIFont fontWithName:@"Zawgyi-One" size:24]];
    [self.piechart setLabelRadius:160];
    [self.piechart setShowPercentage:YES];
    [self.piechart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.piechart setPieCenter:CGPointMake(240, 240)];
    [self.piechart setUserInteractionEnabled:NO];
    [self.piechart setLabelShadowColor:[UIColor blackColor]];
    
    self.allSliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],    [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1], nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"HotSaleBusType" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateHotSaleType:) name:@"didSelectDateHotSaleType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPopularBusType:) name:@"finishGetPopularBusType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAgentHotSaleTrip:) name:@"didSelectAgentHotSaleTrip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReportAgentListByOpid:) name:@"finishReportAgentListByOpid" object:nil];
    
    DataFetcher* datafetcher = [DataFetcher new];
    [datafetcher getReportAgentListByOpid:1];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* tday = [dateFormatter stringFromDate:[NSDate date]];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]]; // Get necessary date components
    
    NSInteger month = [components month]; //gives you month
    NSInteger year = [components year];
    
    [_btnFromDate setTitle:[NSString stringWithFormat:@"%d-%d-01",year, month] forState:UIControlStateNormal];
    [_btnToDate setTitle:tday forState:UIControlStateNormal];
    [_btnAgent setTitle:@"Select All" forState:UIControlStateNormal];
    _selectedagentid = 0;
    
    [self Search:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectDateHotSaleType:(NSNotification*)notification
{
    NSString* strdate = (NSString*)notification.object;
    if (_isFromDate) [_btnFromDate setTitle:strdate forState:UIControlStateNormal];
    else [_btnToDate setTitle:strdate forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)finishReportAgentListByOpid:(NSNotification*)notification
{
//    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)notification.object;
    NSMutableArray* tempmuarr = [tempArr mutableCopy];
    [tempmuarr insertObject:@{@"id": @"0", @"name": @"Select All"} atIndex:0];
    _agentlist = [tempmuarr copy];
}


- (void)finishGetPopularBusType:(NSNotification*)notification
{
    NSArray* temparr = (NSArray*)notification.object;
    
    long totalSeat = 0;
    for (NSDictionary* dict in temparr)
    {
        totalSeat += [dict[@"purchased_total_seat"] longValue];
    }
    
    NSMutableArray* muArr = [[NSMutableArray alloc] initWithCapacity:temparr.count];
    for (NSDictionary* dict in temparr) {
        long seatpercenttage = ([dict[@"purchased_total_seat"] longValue]*100)/totalSeat;
        [muArr addObject:@(seatpercenttage)];
    }
    
    _slices = [muArr copy];
    
    NSMutableArray* colormuArr = [[NSMutableArray alloc] initWithCapacity:_slices.count];
    for (int i = 0; i < _slices.count; i++) {
        [colormuArr addObject:_allSliceColors[i]];
    }
    
    _sliceColors = [colormuArr copy];
    
    [_piechart reloadData];
    
    _dataFiller = [temparr copy];
    
    [_tbIndicator reloadData];
}

- (void)didSelectAgentHotSaleTrip:(NSNotification*)notification
{
    NSDictionary* dict = (NSDictionary*)notification.object;
    [_btnAgent setTitle:dict[@"name"] forState:UIControlStateNormal];
    _selectedagentid = [dict[@"id"] intValue];
    
    [_myPopoverController dismissPopoverAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    if ([segue.identifier isEqualToString:@"agentpopoverbustype"]) {
        SelectAgentGroupVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
        triplistvc.isAgentListShowing = YES;
        triplistvc.tripList = [_agentlist copy];
    }
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
        NSDictionary* dict = @{@"startdate": _btnFromDate.titleLabel.text, @"enddate": _btnToDate.titleLabel.text, @"agentid": @(_selectedagentid)};
        [fetcher getPopularBusType:dict];
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



#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
//    if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
//    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"indicatorcell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"name"];
        cell.cellBtnBkgView.backgroundColor = _sliceColors[indexPath.row];
        
    }
//    else {
//        cell.cellLblDate.text = dict[@"date"];
//        cell.cellLblTotalSeat.text = dict[@"totalSeat"];
//        cell.cellLblTotalSales.text = dict[@"totalSale"];
//    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return footer;
}

@end
