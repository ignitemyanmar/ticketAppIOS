//
//  SelectAgentGroupVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SelectAgentGroupVC.h"
#import "AgentGroup.h"
#import "Reachability.h"

@interface SelectAgentGroupVC () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tvTripList;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@end

@implementation SelectAgentGroupVC

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
        _tripList = @[@"Agent Group 1", @"Agent Group 2", @"Agent Group 3"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadViewHeight];
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
        if (_isAgentListShowing) {
             NSDictionary* dict = _tripList[indexPath.row];
            cell.textLabel.text = dict[@"name"];
        }
        else if (_isTripListShowing) {
            NSDictionary* dict = _tripList[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", dict[@"from_city"], dict[@"to_city"]];
        }
        else {
            AgentGroup* agGp = _tripList[indexPath.row];
            cell.textLabel.text = agGp.name;
        }
    }
    else {
        NSString* str = _tripList[indexPath.row];
        cell.textLabel.text = str;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (_isAgentListShowing) [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectAgentHotSaleTrip" object:_tripList[indexPath.row]];
    else [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectAgentGp" object:_tripList[indexPath.row]];
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

@end
