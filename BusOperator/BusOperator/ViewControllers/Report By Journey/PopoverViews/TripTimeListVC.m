//
//  TripTimeListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripTimeListVC.h"

@interface TripTimeListVC () <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *tvTripList;

@end

@implementation TripTimeListVC

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
    
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    if ([str isEqualToString:@"seatoccupacyreportvc"]) {
        _tripList = [[NSMutableArray alloc] initWithArray:@[@"9:30 AM", @"11:00 AM", @"1:00 PM", @"3:00 PM", @"5:30 PM"]];

    }
    else {
        _tripList = [[NSMutableArray alloc] initWithArray:@[@"9:30 AM", @"11:00 AM", @"1:00 PM", @"3:00 PM", @"5:30 PM"]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    if (![str isEqualToString:@"seatoccupacyreportvc"]) {
    
        [_tripList insertObject:@"All" atIndex:0];
    }
    
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
    
    cell.textLabel.text = _tripList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    if ([str isEqualToString:@"seatoccupacyreportvc"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTimeFromSeatReport" object:selectedCell.textLabel.text];
    }
    else if ([str isEqualToString:@"tripreportvc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectTime" object:selectedCell.textLabel.text];
    }
    else if ([str isEqualToString:@"addbusschedulevc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTimeFromBusSchedule" object:selectedCell.textLabel.text];
    }
    else if ([str isEqualToString:@"departurereport"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTimeDepartureReport" object:selectedCell.textLabel.text];
    }
    else if ([str isEqualToString:@"CreditList"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTimeCreditList" object:selectedCell.textLabel.text];
    
}


@end
