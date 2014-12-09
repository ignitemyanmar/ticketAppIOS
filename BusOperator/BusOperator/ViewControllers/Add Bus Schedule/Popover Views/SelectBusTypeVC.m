//
//  SelectBusTypeVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SelectBusTypeVC.h"

@interface SelectBusTypeVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* busType;
@property (strong, nonatomic) IBOutlet UITableView *tvTripList;

@end

@implementation SelectBusTypeVC

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
    
    _busType = @[@"Bus Type 1", @"Bus Type 2", @"Bus Type 3", @"Bus Type 4"];
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
    return _busType.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"tripListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    cell.textLabel.text = _busType[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBusType" object:selectedCell.textLabel.text];
}


@end
