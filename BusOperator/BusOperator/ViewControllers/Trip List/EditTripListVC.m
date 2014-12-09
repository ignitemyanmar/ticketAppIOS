//
//  EditTripListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/27/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "EditTripListVC.h"
#import "TripReportCell.h"
#import "AddTripVC.h"
#import "ShowHolidayVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "TripDetail.h"
#import "Reachability.h"

@interface EditTripListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedule;
@property (weak, nonatomic) IBOutlet UILabel *lblBusClass;


@property (strong, nonatomic) IBOutlet UITableView *tbEditTirp;
@property (strong, nonatomic) IBOutlet UILabel *lblTripname;

@end

@implementation EditTripListVC

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
    
    _lblTripname.text = _strTrip;
    
    _lblTitleTime.text = @"ကားထြက္ခိ်န္";
    _lblTitleTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblSchedule.text = @"ကားထြက္မည့္ ေန ့ရက္";
    _lblSchedule.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblBusClass.text = @"ကားအမ်ိဴးအစား";
    _lblBusClass.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteTripSchedule:) name:@"finishDeleteTripSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetTripInfoEditListVC:) name:@"finishGetTripInfoEditListVC" object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (!self.reachable) {
        NSDictionary* dict1 = @{@"time": @"10:00 AM", @"available_day":@"Daily", @"classes":@"Business"};
        NSDictionary* dict2 = @{@"time": @"3:30 PM", @"available_day":@"Tue, Thur", @"classes":@"Ordinary"};
        NSDictionary* dict3 = @{@"time": @"6:00 PM", @"available_day":@"Mon", @"classes":@"Special"};
        
        //    NSArray *temparr = @[_tripObj];
        
        _dataFiller = [[NSMutableArray alloc] initWithArray:@[dict1,dict2,dict3]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"edittriplistvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishDeleteTripSchedule:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getTripDetail:_fromid withTo:_toid];
    
}

- (void)finishGetTripInfoEditListVC:(NSNotification*)noti
{
    TripDetail* tripinfo = (TripDetail*)noti.object;
    _dataFiller = [tripinfo.trips mutableCopy];
    [_tbEditTirp reloadData];
}

- (void)deleteTrip:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSDictionary* tripDict = _dataFiller[btn.tag];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
        
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher deleteTripScheduleWithid:tripDict[@"id"]];
    }
    else {
        NSMutableArray* muArr = [[NSMutableArray alloc] initWithArray:_dataFiller];
        [muArr removeObjectAtIndex:btn.tag];
        _dataFiller = [muArr copy];
        [_tbEditTirp reloadData];
    }
    
    
}

- (void)editTrip:(id)sender
{
    
    if (self.reachable) {
        UIButton* btnEdit = (UIButton*)sender;
        NSDictionary* tripinfo = _dataFiller[btnEdit.tag];
        AddTripVC* addtripvc = (AddTripVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddTripVC"];
        addtripvc.previousvc = @"editTrip";
        NSDictionary* dict = @{@"fromCity": _fromCity, @"toCity": _toCity, @"tripDetail": tripinfo};
        addtripvc.preFilledData = [dict copy];
        [self.navigationController pushViewController:addtripvc animated:YES];
    }
    else {
        AddTripVC* addtripvc = (AddTripVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddTripVC"];
        addtripvc.previousvc = @"editTrip";
        [self.navigationController pushViewController:addtripvc animated:YES];
    }
    
}

- (void)setHolidayTrip:(id)sender {
    
    if (self.reachable) {
        UIButton* btnEdit = (UIButton*)sender;
        NSDictionary* tripinfo = _dataFiller[btnEdit.tag];
        
        ShowHolidayVC* destvc = (ShowHolidayVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowHolidayVC"];
        destvc.tripid = tripinfo[@"id"];
        [self.navigationController pushViewController:destvc animated:YES];

    }
    else {
        ShowHolidayVC* destvc = (ShowHolidayVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowHolidayVC"];
        [self.navigationController pushViewController:destvc animated:YES];
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
    NSString* cellid = @"editcell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* tripDict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = tripDict[@"time"];
    cell.cellLblTotalSeat.text = tripDict[@"available_day"];
    cell.cellLblTotalSales.text = tripDict[@"classes"];
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Delete" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(deleteTrip:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btnedit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnedit.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnedit.backgroundColor = [UIColor clearColor];
    [btnedit setTitle:@"Edit" forState:UIControlStateNormal];
    [btnedit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnedit addTarget:self action:@selector(editTrip:) forControlEvents:UIControlEventTouchUpInside];
    
    btnedit.tag = indexPath.row;
    [cell.cellBtnEditBkgView addSubview:btnedit];
    
    UIButton *btnholiday = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnholiday.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnHolidayBkgView.frame.size.width, cell.cellBtnHolidayBkgView.frame.size.height);
    btnholiday.backgroundColor = [UIColor clearColor];
    [btnholiday setTitle:@"Holiday" forState:UIControlStateNormal];
    [btnholiday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnholiday addTarget:self action:@selector(setHolidayTrip:) forControlEvents:UIControlEventTouchUpInside];
    
    btnholiday.tag = indexPath.row;
    [cell.cellBtnHolidayBkgView addSubview:btnholiday];
    
    return cell;
}


@end
