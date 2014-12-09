//
//  TripReportByAllTimeVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripReportByAllTimeVC.h"
#import "TripReportCell.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "TripReportByBusNoVC.h"
#import "JDStatusBarNotification.h"
#import "City.h"
#import "Reachability.h"

@interface TripReportByAllTimeVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* dataFiller;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UIView *bkgView;
@property (strong, nonatomic) IBOutlet UIView *bkgInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDate;

@property (strong, nonatomic) IBOutlet UITableView *_tvAllTimeBusReport;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleBusTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotalSale;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;



@end

@implementation TripReportByAllTimeVC

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
    
    self.title = @"Trip Report By Time";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [self addDashedBorder:_bkgInfo];
    
    _lblTotal.text = @"30000 Ks";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoReportByBus:) name:@"gotoReportByBus" object:nil];
    
    _lblTitleBusTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleBusTime.text = @"ကားထြက္ခ်ိန္";
    
    _lblTitleTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSeat.text = @"ေရာင္းျပီး ခံုုအေရတြက္";

    _lblTitleTotalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း";

    City* fromCity = _dataToPass[@"fromid"];
    City* toCity = _dataToPass[@"toid"];
    _lblTripName.text = [NSString stringWithFormat:@"%@ - %@",fromCity.name,toCity.name];
    _lblTripDate.text = _dataToPass[@"date"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"tripreportbyalltimevc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!self.reachable) {
        _lblTripName.text = @"Yangon - Bago";
        _lblTripDate.text = @"17-7-2014";
        NSDictionary* dict1 = @{@"time": @"10:00 AM", @"totalSeat":@"15/10", @"totalSale":@"30000"};
        NSDictionary* dict2 = @{@"time": @"1:30 PM", @"totalSeat":@"15/10", @"totalSale":@"30000"};
        NSDictionary* dict3 = @{@"time": @"4:30 PM", @"totalSeat":@"15/10", @"totalSale":@"30000"};
        
        _dataFiller = @[dict1, dict2, dict3];

    }
//    long totalAmt = 0;
//    for (NSDictionary* dict in _dataFiller) {
//        totalAmt += [dict[@"total_amout"] longValue];
//    }
//    _lblTotal.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
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

- (void)gotoReportByBus:(NSNotification*)notification
{
    
}

- (void)myAction:(id)sender event:(id)event
{
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:5];
        UIButton* btn = (UIButton*)sender;
        NSArray* keyArr = [_timeDict allKeys];
        NSString* keyStr = keyArr[btn.tag];
        NSMutableArray* arrWithSameTime = [NSMutableArray new];
        for (NSDictionary* dict in _allArr) {
            if ([dict[@"time"] isEqualToString:keyStr]) {
                [arrWithSameTime addObject:dict];
            }
        }
        UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
        TripReportByBusNoVC* tripvc = (TripReportByBusNoVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportByBusNoVC"];
        tripvc.dataFiller = [arrWithSameTime copy];
        tripvc.dataToPass = [_dataToPass copy];
        [self.navigationController pushViewController:tripvc animated:YES];
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        TripReportByBusNoVC* tripvc = (TripReportByBusNoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"TripReportByBusNoVC"];
        [self.navigationController pushViewController:tripvc animated:YES];
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

    if (self.reachable) {
        return [[_timeDict allKeys] count];
    }
    else return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"allbustimecell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    
    if (self.reachable) {
        NSArray* keys = [_timeDict allKeys];
        NSString* keyStr = keys[indexPath.row];
        NSDictionary* myDict = _timeDict[keyStr];

        cell.cellLblDate.text = keyStr;
        cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%d/%d",[myDict[@"purchased_total_seat"] intValue],[myDict[@"total_seat"] intValue]];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%d", [myDict[@"total_amout"] intValue]];
    }
    else {
        NSDictionary* dict = _dataFiller[indexPath.row];
        
        cell.cellLblDate.text = dict[@"time"];
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
