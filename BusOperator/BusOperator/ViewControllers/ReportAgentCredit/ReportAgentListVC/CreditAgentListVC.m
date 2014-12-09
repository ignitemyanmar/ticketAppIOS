//
//  CreditAgentListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/16/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreditAgentListVC.h"
#import "JDStatusBarNotification.h"
#import "TripReportCell.h"
#import "Reachability.h"
#import "DataFetcher.h"
#import "CreditAgentDetailVC.h"

@interface CreditAgentListVC ()

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UILabel *lblAgent;
@property (weak, nonatomic) IBOutlet UILabel *lblPhno;
@property (weak, nonatomic) IBOutlet UILabel *lblPrepaid;
@property (weak, nonatomic) IBOutlet UILabel *lblLefttopay;
@property (weak, nonatomic) IBOutlet UITableView *tbAgentList;


@end

@implementation CreditAgentListVC

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
    
    _lblAgent.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblAgent.text = @"နာမည္";
    
    _lblPhno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblPhno.text = @"ၾကိဳတင္ေငြ";
    
    _lblPrepaid.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblPrepaid.text = @"ယခုုအေၾကြး";
    
    _lblLefttopay.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblLefttopay.text = @"လက္က်န္အေၾကြး";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetCreditAgentList:) name:@"finishGetCreditAgentList" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:3.0f];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCreditAgentList];
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

- (void)finishGetCreditAgentList:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0.0f];
    NSArray* temparr = (NSArray*)notification.object;
    _dataFiller = [temparr copy];
    
    [_tbAgentList reloadData];
}

- (void)viewDetail:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSDictionary* dict = _dataFiller[btn.tag];
    
    CreditAgentDetailVC* nexvc = (CreditAgentDetailVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"CreditAgentDetailVC"];
    nexvc.agentinfo = [dict copy];
    int balance = [dict[@"deposit_balance"] intValue];
    if (balance >= 0) nexvc.prepaidamt = balance;
    else nexvc.prepaidamt = 0;
    [self.navigationController pushViewController:nexvc animated:YES];
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
    
    /*{
     "id": 606,
     "agentgroup_id": 0,
     "name": "\"Golden Bell Family  Travels & Tours\"",
     "phone": "၀၉၄၉၂၉၂၂၅၈၊ ၀၉၄၂၁၁၃၅၄၅၅",
     "address": "အမွတ္(၁၃၆/၁၃၈)၊ အေနာ္ရထာလမ္း၊ (၄၈)လမ္းႏွင့္ ဗုိလ္ျမတ္ထြန္းလမ္းၾကား၊ ဗိုလ္တေထာင္ျမိဳ႔နယ္၊ ရန္ကုန္။",
     "commission_id": 1,
     "commission": 0,
     "user_id": 0,
     "old_credit": 0,
     "operator_id": 11,
     "credit": 0,
     "agent_commission": 0,
     "to_pay_credit": 0,
     "deposit_balance": 0
     }*/
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"name"];
        
        int balance = [dict[@"deposit_balance"] intValue];
        if (balance >= 0) {
            cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@",dict[@"deposit_balance"]];
            cell.cellLblTransactionNo.text = @"0";
        }
        else {
            cell.cellLblTotalSeat.text = @"0";
            cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@",dict[@"deposit_balance"]];
        }
        
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"to_pay_credit"]];
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
