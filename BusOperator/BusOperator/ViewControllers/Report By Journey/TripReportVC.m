//
//  TripReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripReportVC.h"
#import "TripReportCell.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "TripReportByBusNoVC.h"
#import "TripReportByAllTimeVC.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"
#import "TripListVC.h"
#import "City.h"
#import "TripTimeListVC.h"
#import "Reachability.h"

@interface TripReportVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (strong, nonatomic) NSString* strvc;
@property (strong, nonatomic) NSString* strpopoverview;
@property (strong, nonatomic) City* idFromCity;
@property (strong, nonatomic) City* idToCity;
@property (strong, nonatomic) NSString* strTime;
@property (strong, nonatomic) NSArray* fromCityList;
@property (strong, nonatomic) NSArray* toCityList;
@property (strong, nonatomic) City* currentFromCity;
@property (strong, nonatomic) City* currentToCity;
@property (strong, nonatomic) NSArray* timeStrArr;
@property (strong, nonatomic) NSString* strDate;
@property (strong, nonatomic) NSString* strFromDate;
@property (strong, nonatomic) NSString* strToDate;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UIView *buttonsBkgView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnToDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTime;
@property (strong, nonatomic) IBOutlet UITableView *tvTripReport;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleDepartureDate;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSale;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnToCity;

- (IBAction)onbtnFromCityClick:(id)sender;
- (IBAction)onbtnToCityClick:(id)sender;
- (IBAction)Search:(id)sender;


@end

@implementation TripReportVC

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
    
    self.title = @"Trip Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [self addDashedBorder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellViewDetail:) name:@"cellViewDetail" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectFromDate:) name:@"didSelectFromDate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectToDate:) name:@"didSelectToDate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTrip:) name:@"didSelectTrip" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTime:) name:@"didSelectTime" object:nil];
    
    _lblTotal.text = @"";
    
    //Myamar font
    
    _lblTitleDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleDate.text = @"ေရာင္းသည့္ေန႔";
    
    _lblTitleTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSeat.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTitleTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း";
    
    _btnSelectTrip.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTrip setTitle:@"အစခရီးစဥ္" forState:UIControlStateNormal];
    
    _btnToCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnToCity setTitle:@"အဆံုုးခရီးစဥ္" forState:UIControlStateNormal];
    
    _btnSelectTime.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTime setTitle:@"ကားထြက္ခ်ိန္" forState:UIControlStateNormal];
    
    _btnFromDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnFromDate setTitle:@"အစေန ့ရက္" forState:UIControlStateNormal];
    
    _btnToDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnToDate setTitle:@"အဆံုုးေန ့ရက္" forState:UIControlStateNormal];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _lblTitleDepartureDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleDepartureDate.text = @"ထြက္ခြာခ်ိန္";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReportAgentTripListByBus:) name:@"finishReportAgentTripListByBus" object:nil];
    
    _strvc = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentvc"];
    if ([_strvc isEqualToString:@"ReportAgentListVC"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReportAgentTripListByFilter:) name:@"finishReportAgentTripListByFilter" object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishCityByAgentidDownload:) name:@"finishCityListByAgentid" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownloadTimeWithAgentid:) name:@"finishDownloadTimeWithAgentid" object:nil];
        
        if (self.reachable) {
            DataFetcher* fetcher = [DataFetcher new];
            [fetcher getCitiesWithAgentid:_selectedAgentid];
            [fetcher getTimeWithAgentid:_selectedAgentid];
        }
        
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishTripReportByDate:) name:@"finishTripReportByDate" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCityListByOpid:) name:@"finishCityListByOpid" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetTimeWithOpid:) name:@"finishGetTimeWithOpid" object:nil];
        
        if (self.reachable) {
            DataFetcher* fetcher = [DataFetcher new];
            [fetcher getCitiesWithOpid];
            [fetcher getTimeWithOpid];
        }
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"tripreportvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addDashedBorder
{
    //border definitions
    CGFloat cornerRadius = 0;
    CGFloat borderWidth = 1;
    NSInteger dashPattern1 = 4;
    NSInteger dashPattern2 = 4;
    UIColor *lineColor = [UIColor blackColor];
    
    //drawing
    CGRect frame = _buttonsBkgView.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [_buttonsBkgView.layer addSublayer:_shapeLayer];
    _buttonsBkgView.layer.cornerRadius = cornerRadius;
}

#pragma mark - TRIP REPORT NOTI METHODs

- (void)finishTripReportByDate:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* arr = (NSArray*)noti.object;
    _dataFiller = [arr copy];
    [_tvTripReport reloadData];
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amout"] longValue];
    }
    _lblTotal.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
}

- (void)finishCityListByOpid:(NSNotification*)noti
{
    NSDictionary* tempDict = (NSDictionary*)noti.object;
    NSArray* fromArr = tempDict[@"fromCity"];
    _fromCityList = [fromArr copy];
    NSArray* toArr = tempDict[@"toCity"];
    _toCityList = [toArr copy];

}

- (void)finishGetTimeWithOpid:(NSNotification*)noti
{
    _timeStrArr = (NSArray*)noti.object;
}

#pragma mark - AGENT REPORT NOTI METHOD
- (void)finishReportAgentTripListByFilter:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    [_tvTripReport reloadData]; //NEED TO RELOAD BUT NOT NOW
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
      totalAmt += [dict[@"total_amout"] longValue];
    }
    _lblTotal.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
}

- (void)finishReportAgentTripListByBus:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
    if ([_strTime isEqualToString:@""]) {
        
        
        NSMutableDictionary* muDict = [NSMutableDictionary new];
        
        for (NSDictionary* dict in tempArr) {
            NSString* keyTime = dict[@"time"];
            NSMutableDictionary* tempDict = [muDict[keyTime] mutableCopy];
            if (tempDict) {
                int totalSeat = [tempDict[@"total_seat"] intValue];
                int newTotalSeat = [dict[@"total_seat"] intValue];
                int resultSeat = totalSeat+newTotalSeat;
                [tempDict setObject:@(resultSeat) forKey:@"total_seat"];
                
                int totalBuySeat = [tempDict[@"purchased_total_seat"] intValue];
                int newTotalBuySeat = [dict[@"purchased_total_seat"] intValue];
                int resultBuySeat = totalBuySeat+newTotalBuySeat;
                [tempDict setObject:@(resultBuySeat) forKey:@"purchased_total_seat"];
                
                
                int totalAmt = [tempDict[@"total_amout"] intValue];
                int newTotalAmt = [dict[@"total_amout"] intValue];
                int resultTotalAmt = totalAmt+newTotalAmt;
                [tempDict setObject:@(resultTotalAmt) forKey:@"total_amout"];
                [muDict setObject:tempDict forKey:keyTime];
            }
            else {
                tempDict = [NSMutableDictionary new];
                int newTotalSeat = [dict[@"total_seat"] intValue];
                [tempDict setObject:@(newTotalSeat) forKey:@"total_seat"];
                int newTotalBuySeat = [dict[@"purchased_total_seat"] intValue];
                [tempDict setObject:@(newTotalBuySeat) forKey:@"purchased_total_seat"];
                int newTotalAmt = [dict[@"total_amout"] intValue];
                [tempDict setObject:@(newTotalAmt) forKey:@"total_amout"];
                [muDict setObject:tempDict forKey:keyTime];
            }
        }
        
        TripReportByAllTimeVC* tripAllTimeVC = (TripReportByAllTimeVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportByAllTimeVC"];
        tripAllTimeVC.timeDict = [muDict copy];
        tripAllTimeVC.allArr = [tempArr copy];
        NSDictionary* dict = @{@"fromid": _idFromCity,
                               @"toid": _idToCity,
                               @"date": _strDate};
        tripAllTimeVC.dataToPass = [dict copy];
        [self.navigationController pushViewController:tripAllTimeVC animated:YES];
        
        
    }
    else {
        
        TripReportByBusNoVC* tripvc = (TripReportByBusNoVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportByBusNoVC"];
        tripvc.dataFiller = [tempArr copy];
        NSDictionary* dict = @{@"fromid": _idFromCity,
                               @"toid": _idToCity,
                               @"date": _strDate};
        tripvc.dataToPass = [dict copy];
        [self.navigationController pushViewController:tripvc animated:YES];
    }
}

- (void)cellViewDetail:(NSNotification *)notification
{
    
}

- (void)didFinishCityByAgentidDownload:(NSNotification*)noti
{
    NSDictionary* tempDict = (NSDictionary*)noti.object;
    NSArray* fromArr = tempDict[@"fromCity"];
    _fromCityList = [fromArr copy];
    NSArray* toArr = tempDict[@"toCity"];
    _toCityList = [toArr copy];
}

- (void)finishDownloadTimeWithAgentid:(NSNotification*)noti
{
    _timeStrArr = (NSArray*)noti.object;
    
}

- (void)didSelectToDate:(NSNotification*)notification
{
    _strToDate = (NSString*)notification.object;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate* tdate = [df dateFromString:_strToDate];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* newstr = [df stringFromDate:tdate];
    
    [_btnToDate setTitle:newstr forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectFromDate:(NSNotification*)notification
{
    _strFromDate = (NSString*)notification.object;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate* tdate = [df dateFromString:_strFromDate];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* newstr = [df stringFromDate:tdate];
    
    [_btnFromDate setTitle:newstr forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectTrip:(NSNotification*)notification
{
    if (self.reachable) {
        City* city = (City*)notification.object;
        if ([_strpopoverview isEqualToString:@"FromCity"]) {
            [_btnSelectTrip setTitle:city.name forState:UIControlStateNormal];
            _currentFromCity = city;
        }
        else {
            [_btnToCity setTitle:city.name forState:UIControlStateNormal];
            _currentToCity = city;
        }

    }
    else {
        NSString* str = (NSString*)notification.object;
        if ([_strpopoverview isEqualToString:@"FromCity"]) [_btnSelectTrip setTitle:str forState:UIControlStateNormal];
            
        else [_btnToCity setTitle:str forState:UIControlStateNormal];
            
    }
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectTime:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectTime setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    if (self.reachable) {
        if ([segue.identifier isEqualToString:@"fromcitypopover"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_fromCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"tocitypopover"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_toCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"timepopover"])
        {
            TripTimeListVC* triptimelist = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triptimelist.tripList = [_timeStrArr mutableCopy];
        }

    }
}

- (IBAction)onbtnFromCityClick:(id)sender {
    _strpopoverview = @"FromCity";
}

- (IBAction)onbtnToCityClick:(id)sender {
    _strpopoverview = @"ToCity";
}

- (IBAction)Search:(id)sender {
    
    _idFromCity = _currentFromCity;
    _idToCity = _currentToCity;
    _strTime = _btnSelectTime.titleLabel.text;
    if ([_strTime isEqualToString:@"All"]) {
        _strTime = @"";
    }

    if (self.reachable) {
        
        if ([_strvc isEqualToString:@"ReportAgentListVC"]) {
            [self JDStatusBarHidden:NO status:@"Retriving data..." duration:0];
            DataFetcher* fetcher = [DataFetcher new];
            [fetcher getReportAgentTripListByFilterWithOpid:1 withAgentid:_selectedAgentid withFromCity:_currentFromCity.id withToCity:_currentToCity.id withFromDate:_strFromDate withToDate:_strToDate withTime:_strTime];//_selectedAgentid
        }
        else {
            [self JDStatusBarHidden:NO status:@"Retriving data..." duration:0];
            DataFetcher* fetcher = [DataFetcher new];
            [fetcher getReportTripListByFilterWithOpid:1 withFromCity:_currentFromCity.id withToCity:_currentToCity.id withFromDate:_strFromDate withToDate:_strToDate withTime:_strTime];
        }

    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        NSDictionary* dict1 = @{@"date": @"12-5-14", @"totalSeat":@"15/30", @"totalSale":@"30000"};
        NSDictionary* dict2 = @{@"date": @"12-5-14", @"totalSeat":@"15/30", @"totalSale":@"30000"};
        NSDictionary* dict3 = @{@"date": @"12-5-14", @"totalSeat":@"15/30", @"totalSale":@"30000"};
        
        _dataFiller = @[dict1, dict2, dict3];
        [_tvTripReport reloadData];
        
        _lblTotal.text = @"90000 Ks";
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


- (void)myAction:(id)sender event:(id)event
{
    UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
    if ([_strTime isEqualToString:@"All"]) {
        
        
        _strTime = @"";
    }
    UIButton* btn = (UIButton*)sender;
    NSDictionary* dict = _dataFiller[btn.tag];

    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        _strDate = dict[@"order_date"];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getReportAgentTripListByBusWithOpid:1 withAgentid:_selectedAgentid withFromCity:_idFromCity.id withToCity:_idToCity.id withDate:_strDate withTime:_strTime];
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        if ([_strTime isEqualToString:@""]) {
            
            TripReportByAllTimeVC* tripAllTimeVC = (TripReportByAllTimeVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportByAllTimeVC"];
            [self.navigationController pushViewController:tripAllTimeVC animated:YES];
        }
        else {
        
         TripReportByBusNoVC* tripvc = (TripReportByBusNoVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportByBusNoVC"];
        [self.navigationController pushViewController:tripvc animated:YES];
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
    NSString* cellid = @"tripReportCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* tdate = [df dateFromString:dict[@"order_date"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString* newstr = [df stringFromDate:tdate];
        cell.cellLblDate.text = newstr;
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@/%@",dict[@"purchased_total_seat"],dict[@"total_seat"]] ;
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];
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
    [btnCell addTarget:self action:@selector(myAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    return cell;
}
@end
