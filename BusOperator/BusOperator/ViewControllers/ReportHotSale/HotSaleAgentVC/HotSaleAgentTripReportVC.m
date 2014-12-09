//
//  HotSaleAgentTripReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HotSaleAgentTripReportVC.h"
#import "TripReportCell.h"
#import "JDStatusBarNotification.h"
#import "Reachability.h"
#import "DataFetcher.h"
#import "HotSaleTripByTimeVC.h"

@interface HotSaleAgentTripReportVC ()

@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSale;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbpopulartrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;

@end

@implementation HotSaleAgentTripReportVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPopularTripTime:) name:@"finishGetPopularTripTime" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)finishGetPopularTripTime:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* temparr = (NSArray*)notification.object;
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"HotSaleTrip" bundle:nil];
    HotSaleTripByTimeVC* nexvc = (HotSaleTripByTimeVC*)[sb instantiateViewControllerWithIdentifier:@"HotSaleTripByTimeVC"];
    nexvc.dataFiller = [temparr copy];
    [self.navigationController pushViewController:nexvc animated:YES];
    
}

- (void)viewDetail:(id)sender
{
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:3.0f];
        UIButton* btn = (UIButton*)sender;
        NSDictionary* dict = _dataFiller[btn.tag];
        
        NSDictionary* tempdict = @{@"startdate": _fromdate, @"enddate": _todate, @"from": dict[@"from"], @"to": dict[@"to"], @"agentid": @(_agentid)};
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getPopularTripTimeReport:tempdict];
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
    NSString* cellid = @"hotagenttripcell";
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
