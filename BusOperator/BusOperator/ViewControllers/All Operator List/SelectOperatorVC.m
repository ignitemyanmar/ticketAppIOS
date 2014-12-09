//
//  SelectOperatorVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/13/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SelectOperatorVC.h"
#import "JDStatusBarNotification.h"
#import "TicketTypeCell.h"
#import "DataFetcher.h"
#import "Operator.h"
#import "AppDelegate.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "Reachability.h"

@interface SelectOperatorVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) NSArray* dataFiller;

@property (strong, nonatomic) IBOutlet UITableView *tbOperatorList;

@end

@implementation SelectOperatorVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetAllOperators:) name:@"finishGetAllOperators" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"selectOperatorListvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAllOperatorsList];
    }
    else {
        _dataFiller = @[@"Shwe Nan Taw", @"Myat Mingalar Tun"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)finishGetAllOperators:(NSNotification *)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    
    [_tbOperatorList reloadData];
}

- (void)setupTabBarController
{
    UIStoryboard *sb = [UIStoryboard getReportTabStoryboard];
    UIViewController *reportVC= [sb instantiateInitialViewController];
    reportVC.tabBarItem.title = @"REPORTS";
    
    sb = [UIStoryboard getManageTabStoryboard];
    UIViewController *manageVC = [sb instantiateInitialViewController];
    manageVC.tabBarItem.title = @"ကားထြက္ခ်ိန္ စီမံရန္";
    
    sb = [UIStoryboard getTripListTabStoryboard];
    UIViewController *tripListVC = [sb instantiateInitialViewController];
    tripListVC.tabBarItem.title = @"ခရီးစဥ္မ်ား";
    
    sb = [UIStoryboard getAgentTabStoryboard];
    UIViewController *agentVC = [sb instantiateInitialViewController];
    agentVC.tabBarItem.title = @"၀န္ေဆာင္မႈလုုပ္ငန္းမ်ား";
    
    sb = [UIStoryboard getCustomerListStoryboard];
    UIViewController *customerListVC = [sb instantiateInitialViewController];
    customerListVC.tabBarItem.title = @"၀ယ္သူမ်ား";
    
    //    sb = [UIStoryboard getManagePriceTabStoryboard];
    //    UIViewController *managePricevc = [sb instantiateInitialViewController];
    //    managePricevc.tabBarItem.title = @"MANAGE PRICE";
    
    sb = [UIStoryboard getSeatPlanStoryboard];
    UIViewController *seatplanvc = [sb instantiateInitialViewController];
    seatplanvc.tabBarItem.title = @"ထိုုင္ခံုု စီစဥ္ရန္";
    
    sb = [UIStoryboard getAddNewStoryboard];
    UIViewController *addnewvc = [sb instantiateInitialViewController];
    addnewvc.tabBarItem.title = @"စီမံရန္";
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSString* usertype = userinfo[@"type"];
    if ([usertype isEqualToString:@"operator"]) {
        tabBarController.viewControllers = @[tripListVC, agentVC, customerListVC,reportVC, manageVC];
    }
    else {
        tabBarController.viewControllers = @[tripListVC, agentVC, customerListVC,reportVC, manageVC, seatplanvc, addnewvc];
    }
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Zawgyi-One" size:14.0], NSFontAttributeName, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor purpleColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Zawgyi-One" size:14.0], NSFontAttributeName, nil]
                                             forState:UIControlStateSelected];
    
    
    
//    self.window.rootViewController = tabBarController;
    
    [self.navigationController pushViewController:tabBarController animated:YES];
    
}


# pragma mark - UITableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"operatorCell";
    TicketTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.cellLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    if (self.reachable) {
        Operator* opObj = _dataFiller[indexPath.row];
        cell.cellLabel.text = opObj.name;
    }
    else {
        cell.cellLabel.text = _dataFiller[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketTypeCell* customCell = (TicketTypeCell*)cell;
    customCell.cellBkgView.layer.cornerRadius = 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [self setupTabBarController];
    if (self.reachable) {
        Operator* opObj = _dataFiller[indexPath.row];
        NSString* opidStr = opObj.id;
        int opid = [opidStr intValue];
        [[NSUserDefaults standardUserDefaults] setInteger:opid forKey:@"opid"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
    [self setupTabBarController];
}


@end
