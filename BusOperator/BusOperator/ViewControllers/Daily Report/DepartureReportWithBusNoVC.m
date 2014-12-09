//
//  DepartureReportWithBusNoVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DepartureReportWithBusNoVC.h"
#import "TripReportCell.h"
#import "DepartureReportWithSeatNoVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "Reachability.h"

@interface DepartureReportWithBusNoVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tbbusreport;
@property (strong, nonatomic) IBOutlet UILabel *lblBusno;
@property (strong, nonatomic) IBOutlet UILabel *lblBusClass;
@property (strong, nonatomic) IBOutlet UILabel *lblSeatCount;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalSale;
@property (strong, nonatomic) IBOutlet UILabel *lblTrip;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmt;


@end

@implementation DepartureReportWithBusNoVC

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
    
    self.title = @"Bus Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"sold_amount"] longValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    
    _lblBusno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusno.text = @"Bus နံပါတ္";
    
    _lblSeatCount.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSeatCount.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotal.text = @"စုုစုုေပါင္း";
    
    _lblBusClass.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusClass.text = @"အမ်ိဴးအစား";
    
    _lblTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTrip.text = @"ခရီးစဥ္";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetDailyReportBySeat:) name:@"finishGetDailyReportBySeat" object:nil];
    
    if (!self.reachable) {
        NSDictionary* dict1 = @{@"bus_no": @"AA/12345", @"sold_seat":@"5", @"sold_amount":@"10000",  @"class":@"Special", @"from":@"Yangon", @"to":@"Mandalay"};
        NSDictionary* dict2 = @{@"bus_no": @"BB/12345", @"sold_seat":@"5", @"sold_amount":@"10000", @"class":@"Normal",@"from":@"Yangon", @"to":@"Pyay"};
        NSDictionary* dict3 = @{@"bus_no": @"1AA/67890", @"sold_seat":@"5", @"sold_amount":@"10000",@"class":@"VIP", @"from":@"Mandalay", @"to":@"Pyay"};
        
        _dataFiller = @[dict1, dict2, dict3];
        
        _lblTotalAmt.text = @"30000 Ks";

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    NSString* cellid = @"reportbybusCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTransactionNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = dict[@"bus_no"];
    cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"purchased_total_seat"]];
    cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];
    cell.cellLblUnitPrice.text = dict[@"class"];
    cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@ - %@", dict[@"from"], dict[@"to"]];
    
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
