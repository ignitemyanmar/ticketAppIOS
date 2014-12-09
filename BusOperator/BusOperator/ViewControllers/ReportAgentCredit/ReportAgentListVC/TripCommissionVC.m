//
//  TripCommissionVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/20/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripCommissionVC.h"
#import "TripReportCell.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"

@interface TripCommissionVC ()

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UILabel *lblTrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCommtype;
@property (weak, nonatomic) IBOutlet UILabel *lblCommAmt;
@property (weak, nonatomic) IBOutlet UITableView *tbCommission;



@end

@implementation TripCommissionVC

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
    
    _lblTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTrip.text = @"ခရီးစဥ္";
    
    _lblTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTrip.text = @"ခရီးစဥ္";
    
    if(self.reachable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetComm:) name:@"finishGetComm" object:nil];
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* df = [DataFetcher new];
        [df getCommission:_agentid];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetComm:(NSNotification*)notification
{
    NSArray* temparr = (NSArray*)notification.object;
    _dataFiller = [temparr copy];
    [self JDStatusBarHidden:YES status:@"" duration:0];
}

- (void)viewDetail:(id)sender
{
    
}

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"commCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"trip"];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@/%@",dict[@"sold_total_seat"],dict[@"total_seat"]] ;
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amount"]];
        cell.cellLblTransactionNo.text = @""; //
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
