//
//  ShowTripHolidayVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/29/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AddTripHolidayVC.h"
#import "TripReportCell.h"
#import "CKCalendarView.h"

@interface AddTripHolidayVC () <UITableViewDelegate, UITableViewDataSource, CKCalendarDelegate>


@property (strong, nonatomic) NSArray *timeArr;
@property (strong, nonatomic) NSDictionary *timeDict;
@property (assign, nonatomic) int numOfSec;
@property (strong, nonatomic) NSString* popovername;
@property (strong, nonatomic) NSArray *dateArr;
@property (strong, nonatomic) NSMutableArray *dateDictArr;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSArray *busClass;
@property (strong, nonatomic) NSMutableArray *selectedClass;
@property (strong, nonatomic) NSMutableDictionary *chosenClass;
@property (strong, nonatomic) NSString *chosenMenu;
@property (strong, nonatomic) NSIndexPath *chosenIndexPath;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *minimumDate;

@property (strong, nonatomic) IBOutlet UIButton *btnSelectFromCity;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectToCity;
@property (strong, nonatomic) IBOutlet UITableView *tbTripHoliday;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *viewUpper;
@property (strong, nonatomic) IBOutlet UITableView *tbBusClass;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet CKCalendarView *calenderView;
//@property (strong, nonatomic) IBOutlet UIView *viewContentBkg;


- (IBAction)onBtnSelectFromCityClick:(id)sender;
- (IBAction)onBtnSelectToCityClick:(id)sender;

- (IBAction)Search:(id)sender;
- (IBAction)AddTableSection:(id)sender;
- (IBAction)dismissUpperView:(id)sender;

@end

@implementation AddTripHolidayVC

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
    
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(saveTripHoliday) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    _timeArr = @[@"10:00 AM", @"3:30 PM", @"4:30 PM", @"8:00 PM"];
    
    NSArray* sampleArr = @[@"", @"", @""];
    _timeDict = @{@"10:00 AM": sampleArr,
                  @"3:30 PM": sampleArr,
                  @"4:30 PM": sampleArr,
                  @"8:00 PM": sampleArr};
    
    _dateArr = @[@"From Date", @"To Date"];
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"From Date": @"", @"To Date": @""}];
    
    _dateDictArr = [[NSMutableArray alloc] initWithArray:@[muDict]];
    
    _numOfSec = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityFromAddHoliday:) name:@"didSelectCityFromAddHoliday" object:nil];
    
    _busClass = @[@"Business", @"Special", @"Ordinary", @"Normal"];
    
    _viewUpper.hidden = YES;
    
    _selectedClass = [NSMutableArray new];
    _chosenClass = [NSMutableDictionary new];
    
    _calenderView.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-09-20"];
    
    _calenderView.onlyShowCurrentMonth = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"addTripHoliday" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self changeTableviewHeight];
    
    _viewUpper.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _tbBusClass.layer.cornerRadius = 5.0f;
    _tbBusClass.layer.borderColor = [[UIColor blackColor] CGColor];
    _tbBusClass.layer.borderWidth = 3.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveTripHoliday
{
    
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}


- (void)didSelectCityFromAddHoliday:(NSNotification *)notification
{
    NSString* str = (NSString*)notification.object;
    if ([_popovername isEqualToString:@"FromCity"]) {
        [_btnSelectFromCity setTitle:str forState:UIControlStateNormal];
    }
    else if ([_popovername isEqualToString:@"ToCity"]){
        [_btnSelectToCity setTitle:str forState:UIControlStateNormal];
    }
    
    [_myPopoverController dismissPopoverAnimated:YES];

}

- (void)changeTableviewHeight
{

    if (_tbTripHoliday.numberOfSections > 2) {
        
        CGRect frame = _tbTripHoliday.frame;
        frame.size.height = _tbTripHoliday.frame.size.height + 200;
//        [_tbTripHoliday setFrame:frame];
        _tbHeightConstraint.constant = frame.size.height;
//        _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, frame.size.height+500);
    }
    
    
}

- (IBAction)onBtnSelectFromCityClick:(id)sender {
    _popovername = @"FromCity";
}

- (IBAction)onBtnSelectToCityClick:(id)sender {
    _popovername = @"ToCity";
}

- (IBAction)Search:(id)sender {
}

- (IBAction)AddTableSection:(id)sender {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"From Date": @"", @"To Date": @""}];
    [_dateDictArr addObject:muDict];
    _numOfSec++;
//    [_tbTripHoliday beginUpdates];
    [_tbTripHoliday insertSections:[NSIndexSet indexSetWithIndex:_numOfSec-1] withRowAnimation:UITableViewRowAnimationTop];
//    [_tbTripHoliday endUpdates];
    [self changeTableviewHeight];

}

- (IBAction)dismissUpperView:(id)sender {
    _viewUpper.hidden = YES;
    [_tbTripHoliday reloadRowsAtIndexPaths:@[_chosenIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    _viewUpper.hidden = YES;
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict = _dateDictArr[_chosenIndexPath.section-1];
    NSString* str = _dateArr[_chosenIndexPath.row];
    [dict setObject:strDate forKey:_dateArr[_chosenIndexPath.row]];
    

    
    [_dateDictArr replaceObjectAtIndex:_chosenIndexPath.section-1 withObject:dict];
    
    [_tbTripHoliday reloadRowsAtIndexPaths:@[_chosenIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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


# pragma mark - UITableview Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbTripHoliday) {
        return _numOfSec;
    }
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbTripHoliday) {
        NSInteger numOfRow = 0;
        if (section== 0) {
            numOfRow = _timeArr.count;
        }
        else numOfRow = 2;
        return numOfRow;
    }
    else {
        return _busClass.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbTripHoliday) {
        NSString* cellid = @"holidayCell";
        TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        if (indexPath.section == 0) {
            cell.cellLblDate.text = _timeArr[indexPath.row];
            NSArray* tempArr = _chosenClass[_timeArr[indexPath.row]];
            NSMutableString *tempStr = [[NSMutableString alloc] init];
            
            for (int i=0; i < tempArr.count; i++) {
                if (i == tempArr.count-1) {
                    [tempStr appendString:tempArr[i]];
                }
                else [tempStr appendFormat:@"%@, ",tempArr[i]];
            }
            
            if (tempStr.length == 0) {
                cell.cellLblUnitPrice.text = @"";
            }
            else cell.cellLblUnitPrice.text = tempStr;
            
        }
        else {
            cell.cellLblDate.text = _dateArr[indexPath.row];
            NSDictionary* tempDict = _dateDictArr[indexPath.section - 1];
            cell.cellLblUnitPrice.text = tempDict[_dateArr[indexPath.row]];
        }
        return cell;
    }
    else {
        NSString* cellid = @"BusClassCell";
        TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        cell.cellLblDate.text = _busClass[indexPath.row];
        BOOL isFound = NO;
        NSString* currentStr = _busClass[indexPath.row];
        NSArray* tempArr = _chosenClass[_chosenMenu];
        for (NSString* str in tempArr) {
            if ([str isEqualToString:currentStr]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                isFound = YES;
            }
        }
        if (!isFound) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UILabel *lblHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    header.backgroundColor = [UIColor blackColor];
    lblHeaderLabel.textColor = [UIColor whiteColor];
    if (section == 0) {
        if (tableView == _tbTripHoliday) {
            lblHeaderLabel.text = @"Time";
        }
        else lblHeaderLabel.text = @"Choose Bus Class";
        
    }
    else {
        lblHeaderLabel.text = @"Date";
    }
    
    [header addSubview:lblHeaderLabel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AgentCell* customCell = (AgentCell*)cell;
//    customCell.cellbkgView.layer.cornerRadius = 5;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbTripHoliday) {
        _chosenIndexPath = indexPath;
         _viewUpper.hidden = NO;
        
        if (indexPath.section == 0) {
            _chosenMenu = _timeArr[indexPath.row];
            [_tbBusClass reloadData];
            _tbBusClass.hidden = NO;
            _btnDone.hidden= NO;
            _calenderView.hidden = YES;
        }
        else {
            _tbBusClass.hidden = YES;
            _btnDone.hidden = YES;
            _calenderView.hidden = NO;
        }
        
       
        
    }
    else {
        
        if (_tbBusClass.hidden == NO) {
            BOOL isFound = NO;
            
            NSMutableArray* tempClass = [_chosenClass[_chosenMenu] mutableCopy];
            
            if (!tempClass) {
                tempClass = [NSMutableArray new];
            }
            
            NSString* currentStr = _busClass[indexPath.row];
            NSArray* tempArr = [tempClass copy];
            for (NSString* str in tempArr) {
                if ([str isEqualToString:currentStr]) {
                    [tempClass removeObject:str];
                    isFound = YES;
                }
            }
            if (!isFound) {
                [tempClass addObject:_busClass[indexPath.row]];
            }
            [_chosenClass setObject:tempClass forKey:_chosenMenu];
            [_tbBusClass reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        }
        else {
            
        }
    }
}

@end
