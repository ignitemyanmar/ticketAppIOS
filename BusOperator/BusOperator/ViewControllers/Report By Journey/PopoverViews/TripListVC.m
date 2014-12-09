//
//  TripListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripListVC.h"
#import "City.h"
#import "Reachability.h"

@interface TripListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tvTripList;

@end

@implementation TripListVC

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
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    if ([str isEqualToString:@"checkbusschedulevc"]) {
        _tripList = @[@"All", @"YGN - MDY", @"MDY - YGN", @"PYAY - YGN", @"YGN - PYAY"];
    }
    else {
        _tripList = @[@"Yangon", @"Mandalay", @"Pyay", @"Nay Pyi Taw"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Trip List Array is %@",_tripList);
    
    [self reloadViewHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadViewHeight
{
    float currentTotal = 0;
    
    //Need to total each section
    for (int i = 0; i < [self.tvTripList numberOfSections]; i++)
    {
        CGRect sectionRect = [self.tvTripList rectForSection:i];
        currentTotal += sectionRect.size.height;
    }
    
    if (currentTotal > 528.0f)
    {
        currentTotal = 528.0f;
    }
    //Set the contentSizeForViewInPopover
    self.preferredContentSize = CGSizeMake(self.tvTripList.frame.size.width, currentTotal);
}

#pragma mark - UITableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tripList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"tripListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (self.reachable) {
        City* city = _tripList[indexPath.row];
        cell.textLabel.text = city.name;
    }
    else {
        cell.textLabel.text = _tripList[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    if ([str isEqualToString:@"seatoccupacyreportvc"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTripFromSeatReport" object:_tripList[indexPath.row]];
    }
    else if ([str isEqualToString:@"tripreportvc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectTrip" object:_tripList[indexPath.row]];
    }
    else if ([str isEqualToString:@"addbusschedulevc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFromBusSchedule" object:_tripList[indexPath.row]];
    }
    else if ([str isEqualToString:@"checkbusschedulevc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectTripFromCheckBus" object:_tripList[indexPath.row]];

    }
    else if ([str isEqualToString:@"departurereport"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTripDepartureReport" object:_tripList[indexPath.row]];
    }
    else if ([str isEqualToString:@"CreditList"]) [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectCityCreditList" object:_tripList[indexPath.row]];
 
}

@end
