//
//  HotSaleTripByTimeVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HotSaleTripByTimeVC.h"
#import "TripReportCell.h"
#import "Reachability.h"

@interface HotSaleTripByTimeVC ()


@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UITableView *tbPopulartrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBusType;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSeat;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;


@end

@implementation HotSaleTripByTimeVC

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
    
    _lblTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTime.text = @"အခ်ိန္";
    
    _lblBusType.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusType.text = @"အမ်ိဴးအစား";
    
    _lblTotalPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalPrice.text = @"စုုစုုေပါင္း ေငြ";
    
    _lblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotalSeat.text = @"စုုစုုေပါင္း ခံုု";
    
    _lblTitleTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTotal.text = @"စုုစုုေပါင္း :";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"total_amount"] longLongValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
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

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"populartripcell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"time"];
        cell.cellLblTotalSeat.text = dict[@"classes"];
        cell.cellLblTotalSales.text = [NSString stringWithFormat:@"%@/%@",dict[@"sold_total_seat"], dict[@"total_seat"]];
        cell.cellLblUnitPrice.text = [NSString stringWithFormat:@"%@",dict[@"total_amount"]];
        
    }
    else {
        cell.cellLblDate.text = dict[@"seatno"];
        cell.cellLblTotalSeat.text = dict[@"person"];
        cell.cellLblTotalSales.text = dict[@"soldby"];
        cell.cellLblUnitPrice.text = dict[@"unitprice"];
        
    }
    
    return cell;
}


@end
