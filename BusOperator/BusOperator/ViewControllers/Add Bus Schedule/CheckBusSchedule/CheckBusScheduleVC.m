//
//  CheckBusScheduleVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CheckBusScheduleVC.h"
#import "TripReportCell.h"

@interface CheckBusScheduleVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataFiller;
@property (strong, nonatomic) UIPopoverController *mypopoverController;

@property (strong, nonatomic) IBOutlet UIView *bkgView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleBusNo;
@property (strong, nonatomic) IBOutlet UILabel *lblBusTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *totalSale;
@property (strong, nonatomic) IBOutlet UITableView *tvBusSchedule;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTrip;


- (IBAction)selectTrip:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)Search:(id)sender;


@end

@implementation CheckBusScheduleVC

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
    
    self.title = @"Bus Schedule";
    
    _dataFiller = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTripFromCheckBus:) name:@"didSelectTripFromCheckBus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateFromCheckBus:) name:@"didSelectDateFromCheckBus" object:nil];
    
    _lblTitleBusNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleBusNo.text = @"Bus နံပါတ္";
    
    _lblBusTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusTime.text = @"ကားထြက္ခ်ိန္";
    
    _lblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSeat.text = @"ေရာင္းျပီး ခံုုအေရတြက္";
    
    _totalSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _totalSale.text = @"စုုစုုေပါင္း ေရာင္းရေငြ";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း";
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _lblTitleTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTrip.text = @"ခရီးစဥ္";
    
    _btnSelectTrip.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTrip setTitle:@"ခရီးစဥ္" forState:UIControlStateNormal];
    
    _btnSelectDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectDate setTitle:@"ေန ့ရက္" forState:UIControlStateNormal];
    
    _lblTotal.text = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"checkbusschedulevc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _mypopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (void)didSelectTripFromCheckBus:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectTrip setTitle:str forState:UIControlStateNormal];
    [_mypopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectDateFromCheckBus:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectDate setTitle:str forState:UIControlStateNormal];
    [_mypopoverController dismissPopoverAnimated:YES];
}

- (IBAction)selectTrip:(id)sender {
}

- (IBAction)selectDate:(id)sender {
}

- (IBAction)Search:(id)sender {
    
    if ([_btnSelectTrip.titleLabel.text isEqualToString:@"ခရီးစဥ္"]) {
        return;
    }
    
    [_dataFiller removeAllObjects];
    NSDictionary* dict1 = @{@"busno": @"AA/1234", @"time":@"1:00 PM", @"seat":@"15/30", @"total":@"75000 Ks", @"trip":@"YGN - MDY"};
    NSDictionary* dict2 = @{@"busno": @"BB/4567", @"time":@"10:00 AM", @"seat":@"2/30", @"total":@"10000 Ks", @"trip":@"MDY - YGN"};
    NSDictionary* dict3 = @{@"busno": @"1A/2345", @"time":@"3:00 PM", @"seat":@"5/15", @"total":@"25000 Ks", @"trip":@"YGN - MDY"};
    NSDictionary* dict4 = @{@"busno": @"3A/2345", @"time":@"5:00 PM", @"seat":@"6/15", @"total":@"30000 Ks", @"trip":@"PYAY - YGN"};
    NSDictionary* dict5 = @{@"busno": @"3B/6547", @"time":@"7:00 PM", @"seat":@"1/15", @"total":@"5000 Ks", @"trip":@"YGN - PYAY"};
    
    NSArray *tempArr = @[dict1, dict2, dict3, dict4, dict5];
    
    if ([_btnSelectTrip.titleLabel.text isEqualToString:@"All"]) {
        _dataFiller = [tempArr mutableCopy];
        _lblTotal.text = @"145000 Ks";
    }
    else
    {
        for (NSDictionary* dict in tempArr) {
            if ([dict[@"trip"] isEqualToString:_btnSelectTrip.titleLabel.text]) {
                [_dataFiller addObject:dict];
            }
        }
        
        int totalPrice = 0;
        for (NSDictionary* dict in _dataFiller) {
            totalPrice += [dict[@"total"] intValue];
        }
        
        _lblTotal.text = [NSString stringWithFormat:@"%d Ks",totalPrice];
    }
    
    [_tvBusSchedule reloadData];
    
    
}

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"checkbusCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.text = dict[@"busno"];
    cell.cellLblTotalSeat.text = dict[@"time"];
    cell.cellLblTotalSales.text = dict[@"seat"];
    cell.cellLblUnitPrice.text = dict[@"total"];
    cell.cellLblTransactionNo.text = dict[@"trip"];
    
    return cell;
}

@end
