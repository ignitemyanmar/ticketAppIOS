//
//  ChooseSeatPlanVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/16/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ChooseSeatPlanVC.h"
#import "Reachability.h"

@interface ChooseSeatPlanVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) IBOutlet UITableView *tvTripList;

@end

@implementation ChooseSeatPlanVC

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
    
    if (!self.reachable) {
        _tripList = @[@"Operator-60"];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    NSString* cellid = @"seatPlanCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.textLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    if (self.reachable) {
        NSDictionary* dict = _tripList[indexPath.row];
        cell.textLabel.text = dict[@"name"];
    }
    else cell.textLabel.text = _tripList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectBusSeatPlan" object:_tripList[indexPath.row]];
    
}

@end
