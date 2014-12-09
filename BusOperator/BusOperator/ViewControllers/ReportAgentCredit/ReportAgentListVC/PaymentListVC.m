//
//  PaymentListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/21/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "PaymentListVC.h"
#import "TripReportCell.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"

@interface PaymentListVC ()

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UILabel *lblPrepaidDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditDatr;
@property (weak, nonatomic) IBOutlet UILabel *lblPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblLefttopay;
@property (weak, nonatomic) IBOutlet UITableView *tbPaymentList;


@end

@implementation PaymentListVC

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
    
    _lblPrepaidDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblPrepaidDate.text = @"ၾကိဳေငြေပးသြင္းသည့္ေန ့";
    
    _lblCreditDatr.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblCreditDatr.text = @"အေၾကြးေပးသြင္းသည့္ေန ့";
    
    _lblPayment.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblPayment.text = @"ေပးေငြ";
    
    _lblCredit.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblCredit.text = @"အေၾကြး";
    
    _lblLefttopay.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblLefttopay.text = @"လက္က်န္ေငြ";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetPaymentHistory:) name:@"finishGetPaymentHistory" object:nil];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* df = [DataFetcher new];
        [df getPaymentHistory:_agentid];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetPaymentHistory:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* arr = (NSArray*)notification.object;
    _dataFiller = [arr copy];
    
    [_tbPaymentList reloadData];
    
}

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"creditagentcell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTransactionNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTextExtra.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    
     /*
     {
     "id": 130,
     "agent_id": 606,
     "operator_id": 11,
     "deposit_date": "2014-10-17",
     "deposit": 500,
     "total_ticket_amt": 0,
     "payment": 0,
     "pay_date": "0000-00-00",
     "balance": 500,
     "debit": 0,
     "agent": "\"Golden Bell Family  Travels & Tours\""
     }
     */
    
    
    if (self.reachable) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* tdate = [df dateFromString:dict[@"deposit_date"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString* newstr = [df stringFromDate:tdate];
        
        cell.cellLblDate.text = newstr;
        
        [df setDateFormat:@"yyyy-MM-dd"];
        tdate = [df dateFromString:dict[@"pay_date"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        newstr = [df stringFromDate:tdate];
        
        cell.cellLblTotalSeat.text = newstr;
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"payment"]];
        cell.cellLblTextExtra.text = [NSString stringWithFormat:@"%@",dict[@"balance"]];
        cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@",dict[@"deposit"]];
    }
    else {
        cell.cellLblDate.text = dict[@"date"];
        cell.cellLblTotalSeat.text = dict[@"totalSeat"];
        cell.cellLblTotalSales.text = dict[@"totalSale"];
    }
    
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
