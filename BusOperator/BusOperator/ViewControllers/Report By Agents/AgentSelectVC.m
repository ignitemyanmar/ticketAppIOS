//
//  AgentSelectVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AgentSelectVC.h"
#import "AgentCell.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "TripReportVC.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"
#import "Agent.h"
#import "Reachability.h"

@interface AgentSelectVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tvAgents;

@property (strong, nonatomic) NSArray* agentList;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;


@end

@implementation AgentSelectVC

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
    
    self.title = @"Bus Agents";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReportAgentListByOpid:) name:@"finishReportAgentListByOpid" object:nil];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving Agent List..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getReportAgentListByOpid:1]; // PASS OPERATOR ID GOT BY LOGGING IN
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        _agentList = @[@"City Mart",@"Agent 1",@"Agent 2", @"Agent 3", @"Agent 4", @"Agent 5",@"Agent 6",@"Agent 7",@"Agent 8",@"Agent 9", @"Agent 10"];
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ReportAgentListVC" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishReportAgentListByOpid:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _agentList = [tempArr copy];
    [_tvAgents reloadData]; //ASA API WORKS, NEED TO RELOAD BUT NOT NOW
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


# pragma mark - UITableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _agentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"agentCell";
    AgentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    cell.celllblText.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        NSDictionary* dict = _agentList[indexPath.row]; //CHANGE FORMAT WITH AGENT OBJ
        cell.celllblText.text = dict[@"name"];
    }
    else {
        cell.celllblText.text = _agentList[indexPath.row];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AgentCell* customCell = (AgentCell*)cell;
    customCell.cellbkgView.layer.cornerRadius = 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.reachable) {
        NSDictionary* dict = _agentList[indexPath.row];
        UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
        TripReportVC* tripvc = (TripReportVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportVC"];
        tripvc.selectedAgentid = [dict[@"id"] intValue]; //sub_agent's id NOT agent GROUP's id
        [self.navigationController pushViewController:tripvc animated:YES];

    }
    else {
        UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
        TripReportVC* tripvc = (TripReportVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportVC"];
        [self.navigationController pushViewController:tripvc animated:YES];
    }
    
}

@end
