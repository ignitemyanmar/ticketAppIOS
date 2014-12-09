//
//  ShowHolidayVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ShowHolidayVC.h"
#import "TripReportCell.h"
#import "HolidayDateVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "Reachability.h"

@interface ShowHolidayVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (weak, nonatomic) IBOutlet UITableView *tbHoliday;


@end

@implementation ShowHolidayVC

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Add Holiday" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(addNewHoliday) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetHoliday:) name:@"finishGetHoliday" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteHoliday:) name:@"finishDeleteHoliday" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getHoliday:_tripid];
    }
    else _dataFiller = @[@"12-7-14 - 15-7-2014", @"12-8-14 - 15-8-2014", @"18-8-14 - 22-8-2014"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetHoliday:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSDictionary* dict = (NSDictionary*)noti.object;
    NSArray* tempArr = dict[@"holidays"];
    _dataFiller = [tempArr copy];
    
    [_tbHoliday reloadData];
    
}

- (void)finishDeleteHoliday:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getHoliday:_tripid];
}

- (void)addNewHoliday {
    
    HolidayDateVC* nexvc = (HolidayDateVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"HolidayDateVC"];
    nexvc.tripid = _tripid;
    nexvc.useraction = @"add";
    [self presentViewController:nexvc animated:YES completion:nil];

    
}

- (void)deleteTrip:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSDictionary* tripinfo = _dataFiller[btn.tag];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher deleteHolidayWithTripid:_tripid withHolidayid:tripinfo[@"holiday_id"]];
    }
    else {
        NSMutableArray* muArr = [[NSMutableArray alloc] initWithArray:_dataFiller];
        [muArr removeObjectAtIndex:btn.tag];
        _dataFiller = [muArr copy];
        [_tbHoliday reloadData];
    }
    
}

- (void)editTrip:(id)sender
{
    if (self.reachable) {
        UIButton* btnEdit = (UIButton*)sender;
        NSDictionary* tripinfo = _dataFiller[btnEdit.tag];
        HolidayDateVC* nexvc = (HolidayDateVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"HolidayDateVC"];
        nexvc.tripid = _tripid;
        nexvc.useraction = @"edit";
        nexvc.holidayid = tripinfo[@"holiday_id"];
        [self presentViewController:nexvc animated:YES completion:nil];

    }
    else {
        HolidayDateVC* nexvc = (HolidayDateVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"HolidayDateVC"];
        nexvc.useraction = @"edit";
        [self presentViewController:nexvc animated:YES completion:nil];
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
    
//    NSDictionary* tripDict = _dataFiller[indexPath.row];
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        NSDictionary* dict = _dataFiller[indexPath.row];
        cell.cellLblDate.text = [NSString stringWithFormat:@"%@ - %@",dict[@"from_date"],dict[@"to_date"]];
    }
    else {
        cell.cellLblDate.text = _dataFiller[indexPath.row];
    }
    
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
    
    return cell;
}


@end
