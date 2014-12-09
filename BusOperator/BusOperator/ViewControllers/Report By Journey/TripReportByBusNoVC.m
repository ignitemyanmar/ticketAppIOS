//
//  TripReportByBusNoVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripReportByBusNoVC.h"
#import "TripReportCell.h"
#import "TripReportBySeatNoVC.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"
#import "City.h"
#import "Reachability.h"

@interface TripReportByBusNoVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* selectedDepartureDate;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tvReportWithBusNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTripTime;

@property (strong, nonatomic) IBOutlet UIView *bkgInfoView;
@property (strong, nonatomic) IBOutlet UILabel *lblTripInfo;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleBusno;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalSale;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblBusClass;
//@property (strong, nonatomic) IBOutlet UILabel *lblTirp;
@property (strong, nonatomic) IBOutlet UILabel *lblDepartureDate;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleTrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTime;



@end

@implementation TripReportByBusNoVC

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
    
    self.title = @"Trip Report By Bus";
    
//    NSDictionary* dict1 = @{@"bus_no": @"AA/12345", @"total_seat":@"5",@"purchased_total_seat":@"10", @"total_amout":@"10000"};
//    NSDictionary* dict2 = @{@"bus_no": @"BB/12345", @"total_seat":@"5",@"purchased_total_seat":@"10", @"total_amout":@"10000"};
//    NSDictionary* dict3 = @{@"bus_no": @"1AA/67890", @"total_seat":@"5",@"purchased_total_seat":@"10", @"total_amout":@"10000"};
//    
//    _dataFiller = @[dict1, dict2, dict3];
    
    [self addDashedBorder:_bkgInfoView];
    [self addDashedBorder:_lblTripInfo];
    
    _lblTotal.text = @"30000 Ks";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoReportBySeat:) name:@"gotoReportBySeat" object:nil];
    
    _lblTitleBusno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleBusno.text = @"Bus နံပါတ္";
    
    _lblTitleTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSeat.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _lblTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း";
    
    _lblDepartureDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDepartureDate.text = @"ကားထြက္မည့္ ေန ့ရက္";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAgentReportSeatNo:) name:@"finishAgentReportSeatNo" object:nil];
    
    _lblTripName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    City* fromCity = _dataToPass[@"fromid"];
    City* toCity = _dataToPass[@"toid"];
    _lblTripName.text = [NSString stringWithFormat:@"%@ - %@",fromCity.name,toCity.name];
    _lblTripDate.text = _dataToPass[@"date"];
    if (_dataFiller.count > 0) {
        NSDictionary* myDict = _dataFiller[0];
        _lblTripTime.text = myDict[@"time"];
    }
    
    
    _lblTitleDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleDate.text = @"ေရာင္းသည့္ေန႔:";
    
    _lblTitleTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTrip.text = @"ခရီးစဥ္ :";

    _lblTitleTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTime.text = @"ကားထြက္ခ်ိန္ :";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"tripreportbybusnovc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (self.reachable) {
        long totalAmt = 0;
        for (NSDictionary* dict in _dataFiller) {
            totalAmt += [dict[@"total_amout"] longValue];
        }
        _lblTotal.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    }
    else {
        _lblTripName.text = @"Yangon - Mandalay";
        _lblTripDate.text = @"17-7-2014";
        _lblTripTime.text = @"09:30 AM";
        
        NSDictionary* dict1 = @{@"date": @"AA/12345", @"totalSeat":@"5/10", @"totalSale":@"10000", @"departure_date":@"17-7-2014"};
        NSDictionary* dict2 = @{@"date": @"BB/12345", @"totalSeat":@"5/10", @"totalSale":@"10000", @"departure_date": @"19-7-2014"};
        NSDictionary* dict3 = @{@"date": @"1AA/67890", @"totalSeat":@"5/10", @"totalSale":@"10000", @"departure_date": @"23-7-2014"};
        
        _dataFiller = @[dict1, dict2, dict3];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addDashedBorder:(UIView*)view
{
    //border definitions
    CGFloat cornerRadius = 0;
    CGFloat borderWidth = 1;
    NSInteger dashPattern1 = 4;
    NSInteger dashPattern2 = 4;
    UIColor *lineColor = [UIColor blackColor];
    
    //drawing
    CGRect frame = view.bounds;
    
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
    [view.layer addSublayer:_shapeLayer];
    view.layer.cornerRadius = cornerRadius;
}

- (void)gotoReportBySeat:(NSNotification*)notification
{
}

- (void)finishAgentReportSeatNo:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* seatNoReportArr = (NSArray*)noti.object;
    UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
    TripReportBySeatNoVC* tripvc = (TripReportBySeatNoVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportBySeatNoVC"];
    tripvc.dataFiller = [seatNoReportArr copy];
//    tripvc.dataToPass = [_dataToPass copy];
    NSDictionary* myDict = _dataFiller[0];
    NSDictionary* dict = @{@"tripName": _lblTripName.text, @"tripDate": _lblTripDate.text, @"tripTime": _lblTripTime.text, @"busno": myDict[@"bus_no"], @"departuredate": _selectedDepartureDate};
    tripvc.dataToPass = [dict copy];
    [self.navigationController pushViewController:tripvc animated:YES];
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
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        UIButton* btn = (UIButton*)sender;
        NSDictionary* myDict = _dataFiller[btn.tag];
        _selectedDepartureDate = myDict[@"departure_date"];
        City* fromCity = _dataToPass[@"fromid"];
        City* toCity = _dataToPass[@"toid"];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getReportAgentSeatNoWithOpid:1 withFromCity:fromCity.id withToCity:toCity.id withDate:_dataToPass[@"date"] withTime:myDict[@"time"] withBusNo:myDict[@"bus_id"]];
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        TripReportBySeatNoVC* tripvc = (TripReportBySeatNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"TripReportBySeatNoVC"];
        [self.navigationController pushViewController:tripvc animated:YES];
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
    NSString* cellid = @"tripReportByBusCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"bus_no"];
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%@/%@",dict[@"purchased_total_seat"],dict[@"total_seat"]];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@",dict[@"total_amout"]];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* tdate = [df dateFromString:dict[@"departure_date"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString* newstr = [df stringFromDate:tdate];
        cell.cellLblUnitPrice.text = newstr;

    }
    else {
        cell.cellLblDate.text = dict[@"date"];
        cell.cellLblTotalSeat.text = dict[@"totalSeat"];
        cell.cellLblTotalSales.text = dict[@"totalSale"];
        cell.cellLblUnitPrice.text = dict[@"departure_date"];

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
