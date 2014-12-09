//
//  HolidayDateVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HolidayDateVC.h"
#import "TripReportCell.h"
#import "CKCalendarView.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "Reachability.h"

@interface HolidayDateVC () <UITableViewDelegate, UITableViewDataSource,CKCalendarDelegate>

@property (strong, nonatomic) NSArray* arrCellLbl;
@property (strong, nonatomic) NSString* strFromDate;
@property (strong, nonatomic) NSString* strToDate;
@property (strong, nonatomic) NSMutableArray* arrCellDate;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* minimumDate;
@property (strong, nonatomic) NSIndexPath* selectedrow;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet CKCalendarView *calenderView;
@property (weak, nonatomic) IBOutlet UITableView *tbFromToDate;
- (IBAction)DismissUpperView:(id)sender;
- (IBAction)Cancel:(id)sender;
- (IBAction)Save:(id)sender;

@end

@implementation HolidayDateVC

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
    
    _arrCellLbl = @[@"From Date", @"To Date"];
    
    _strFromDate = @"";
    _strToDate = @"";
    _arrCellDate = [[NSMutableArray alloc] initWithArray:@[_strFromDate, _strToDate]];
    
    _calenderView.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-09-20"];
    
    _calenderView.onlyShowCurrentMonth = NO;
    
    _upperView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _upperView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAddHoliday:) name:@"finishAddHoliday" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateHoliday:) name:@"finishUpdateHoliday" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NOTIFICATION METHODS

- (void)finishAddHoliday:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishUpdateHoliday:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)DismissUpperView:(id)sender {
    _upperView.hidden = YES;
}

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Save:(id)sender {
    //POST API
    //IF USER CLICEKED ADD HOLIDAY'
    if (_strFromDate.length > 0 && _strToDate.length > 0) {
        if (self.reachable) {
            [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
            DataFetcher* fetcher = [DataFetcher new];
            
            if ([_useraction isEqualToString:@"add"]) {
                NSDictionary* dict = @{@"tripid": _tripid,
                                       @"startdate": _strFromDate,
                                       @"enddate": _strToDate};
                [fetcher addHoliday:dict];
            }
            else {
                NSDictionary* dict = @{@"tripid": _tripid,
                                       @"startdate": _strFromDate,
                                       @"enddate": _strToDate,
                                       @"holidayid": _holidayid};
                [fetcher updateHoliday:dict];
            }

        }
        else {
            [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        }
        
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


#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    //    if ([self dateIsDisabled:date]) {
    //        dateItem.backgroundColor = [UIColor redColor];
    //        dateItem.textColor = [UIColor whiteColor];
    //    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;//![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    _upperView.hidden = YES;
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    
    [_arrCellDate insertObject:strDate atIndex:_selectedrow.row];
    
    if (_selectedrow.row == 0) {
        _strFromDate = strDate;
    }
    else _strToDate = strDate;
    
    [_tbFromToDate reloadRowsAtIndexPaths:@[_selectedrow] withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        _calenderView.backgroundColor = [UIColor colorWithRed:19.0/255 green:62.0/255 blue:72.0/255 alpha:1];
        return YES;
    } else {
        _calenderView.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

#pragma mark - UITABLEVIEW METHODS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"holidaydateCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.cellLblDate.text = _arrCellLbl[indexPath.row];
    cell.cellLblUnitPrice.text = _arrCellDate[indexPath.row];
    
    if (indexPath.row == 1) {
        cell.cellSeperator.hidden = YES;
    }
    else cell.cellSeperator.hidden = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedrow = indexPath;
    _upperView.hidden = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

@end
