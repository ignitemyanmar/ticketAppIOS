//
//  ShowTripHolidayVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/30/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ShowTripHolidayVC.h"
#import "TripReportCell.h"
#import "AddTripHolidayVC.h"

@interface ShowTripHolidayVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *tripDict;
@property (strong, nonatomic) NSArray *tripKeyArr;
@property (strong, nonatomic) IBOutlet UITableView *tbHolidayList;


@end

@implementation ShowTripHolidayVC

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
    
    [button setTitle:@"Add Trip Holiday Plan" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 180, 40);
    [button addTarget:self action:@selector(goToAddTripHoliday) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;

    
    NSDictionary *dict1 = @{@"time": @"10:00 AM", @"class":@"Business, Normal", @"date": @"17/5/14 - 20/5/14"};
    
    NSDictionary *dict2 = @{@"time": @"12:00 PM", @"class":@"Business", @"date": @"17/5/14 - 20/5/14"};
    
    NSDictionary *dict3 = @{@"time": @"1:00 PM", @"class":@"Normal", @"date": @"17/5/14 - 20/5/14"};
    
    _tripDict = @{@"YGN-MDY": @[dict1,dict2],@"MDY-YGN":@[dict2,dict3], @"YGN-PYAY": @[dict3,dict1]};
    _tripKeyArr = [_tripDict allKeys];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Trip Holiday Schedule";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToAddTripHoliday
{
    AddTripHolidayVC* destVC = (AddTripHolidayVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"AddTripHolidayVC"];
    [self.navigationController pushViewController:destVC animated:YES];
}

# pragma mark - UITableview Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tripKeyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* strKey = _tripKeyArr[section];
    NSArray* tempArr = _tripDict[strKey];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"showHolidayCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSString* strKey = _tripKeyArr[indexPath.section];
    NSArray* tempArr = _tripDict[strKey];
    NSDictionary *tempDict = tempArr[indexPath.row];
    
    cell.cellLblDate.text = tempDict[@"time"];
    cell.cellLblTotalSeat.text = tempDict[@"class"];
    cell.cellLblTotalSales.text = tempDict[@"date"];
        
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tbHolidayList.frame.size.width, 40)];
    bkgView.backgroundColor = [UIColor grayColor];
    
    UILabel *lblHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    header.backgroundColor = [UIColor blackColor];
    lblHeaderLabel.textColor = [UIColor whiteColor];
    
    lblHeaderLabel.text = _tripKeyArr[section];
    
    [bkgView addSubview:lblHeaderLabel];
    [header addSubview:bkgView];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 30)];
    lblTime.textColor = [UIColor whiteColor];
    lblTime.text = @"Time";
    [header addSubview:lblTime];
    
    UILabel *lblClass = [[UILabel alloc] initWithFrame:CGRectMake(310, 40, 400, 30)];
    lblClass.textColor = [UIColor whiteColor];
    lblClass.text = @"Bus Class";
    [header addSubview:lblClass];
    
    UILabel *lblHoliday = [[UILabel alloc] initWithFrame:CGRectMake(680, 40, 400, 30)];
    lblHoliday.textColor = [UIColor whiteColor];
    lblHoliday.text = @"Holiday";
    [header addSubview:lblHoliday];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
