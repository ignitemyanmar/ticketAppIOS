//
//  TripListTabVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripListTabVC.h"
#import "AgentCell.h"
#import "AddTripVC.h"
#import "EditTripListVC.h"
#import "City.h"
#import "Trip.h"
#import "DataFetcher.h"
#import "TripDetail.h"
#import "JDStatusBarNotification.h"
#import "Reachability.h"

@interface TripListTabVC () <UITableViewDataSource, UITableViewDelegate>
{
    int modifyY;
}

@property (strong, nonatomic) NSArray *tripList;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSString *fromid;
@property (strong, nonatomic) NSString *toid;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tbTripList;

@end

@implementation TripListTabVC

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
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishTripsDownload:) name:@"didFinishTripsDownload" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishTripInfoDownload:) name:@"finishTripInfoDownload" object:nil];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* dataFetch = [DataFetcher new];
        [dataFetch getAllTrips];
    }
    else {
        _tripList = @[@"Yangon - Mandalay", @"Yangon - Bago", @"Mandalay - Yangon", @"Bagon - Yangon"];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"triplisttabvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"ခရီးစဥ္ အသစ္ထည့္ပါ" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [button setBackgroundColor:[UIColor colorWithRed:116.0f/255 green:206.0f/255 blue:113.0f/255 alpha:1]];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(addNewTrip) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSString* usertype = userinfo[@"type"];
    if (![usertype isEqualToString:@"operator"]) {
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backbtn setTitle:@"< ခရီးသြားလုုပ္ငန္း ေရြးရန္" forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [backbtn setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    backbtn.adjustsImageWhenDisabled = NO;
    backbtn.frame = CGRectMake(0, 0, 150, 40);
    [backbtn addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    backbtn.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *backbaritem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    
    self.navigationItem.leftBarButtonItem = backbaritem;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dismissThisView
{
   [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didFinishTripsDownload:(NSNotification *)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* result = (NSArray*)noti.object;
    _tripList = result;
    [_tbTripList reloadData];
}

- (void)finishTripInfoDownload:(NSNotification *)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    TripDetail* tripinfo = (TripDetail*)noti.object;
    EditTripListVC* editvc = (EditTripListVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"EditTripListVC"];
    editvc.strTrip = [NSString stringWithFormat:@"%@-%@",tripinfo.from,tripinfo.to];
    editvc.dataFiller = [tripinfo.trips mutableCopy];
    NSLog(@"tripinfo.trips = %@",tripinfo.trips);
    editvc.fromCity = tripinfo.from;
    editvc.toCity = tripinfo.to;
    editvc.fromid = _fromid;
    editvc.toid = _toid;
    [self.navigationController pushViewController:editvc animated:YES];
}

- (void)addNewTrip
{
    AddTripVC *destvc = (AddTripVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddTripVC"];
    [self.navigationController pushViewController:destvc animated:YES];
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
    return _tripList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"tripCell";
    AgentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.celllblText.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    if (self.reachable) {
        Trip* trip = _tripList[indexPath.row];
        
        cell.celllblText.text = [NSString stringWithFormat:@"%@ - %@",trip.from_city,trip.to_city];
    }
    else cell.celllblText.text = _tripList[indexPath.row];
    
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
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        Trip* trip = _tripList[indexPath.row];
        _fromid = trip.from;
        _toid = trip.to;
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getTripDetail:trip.from withTo:trip.to];
    }
    else {
        EditTripListVC* editvc = (EditTripListVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"EditTripListVC"];
        [self.navigationController pushViewController:editvc animated:YES];
    }
    
}

@end
