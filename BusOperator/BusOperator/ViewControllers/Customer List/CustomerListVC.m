//
//  CustomerListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CustomerListVC.h"
#import "TripReportCell.h"
#import "DataFetcher.h"
#import "Customer.h"
#import "JDStatusBarNotification.h"

@interface CustomerListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataFiller;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITableView *tbCustomerList;
@property (strong, nonatomic) IBOutlet UIView *viewUpper;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtNRC;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIView *viewUpperContent;

- (IBAction)Cancel:(id)sender;
- (IBAction)Save:(id)sender;

@end

@implementation CustomerListVC

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
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [button setTitle:@"Add New Customer" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
//    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
//    button.layer.borderWidth = 1.0f;
//    button.layer.cornerRadius = 5.0f;
//    button.adjustsImageWhenDisabled = NO;
//    button.frame = CGRectMake(0, 0, 180, 40);
//    [button addTarget:self action:@selector(addNewCustomer) forControlEvents:UIControlEventTouchUpInside];
//    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navigationItem.rightBarButtonItem = customBarItem;
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSString* usertype = userinfo[@"type"];
    if (![usertype isEqualToString:@"operator"]) {
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backbtn setTitle:@"< ခရီးသြားလုုပ္ငန္း ေရြးရန္" forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [backbtn setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    backbtn.adjustsImageWhenDisabled = NO;
    backbtn.frame = CGRectMake(0, 0, 150, 40);
    [backbtn addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    backbtn.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *backbaritem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    
    self.navigationItem.leftBarButtonItem = backbaritem;
    }
    
//    _dataFiller = @[@{@"name": @"Daw Aye", @"nrc": @"12/lmn(N)090909"},@{@"name": @"U Hla", @"nrc": @"12/MTN(N)090909"}];
    
    [_segmentControl addTarget:self action:@selector(SegmentControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    _viewUpper.hidden = YES;
    _viewUpper.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _viewUpperContent.layer.cornerRadius = 5.0f;
    _viewUpperContent.layer.borderColor  = [[UIColor blackColor] CGColor];
    _viewUpperContent.layer.borderWidth = 3.0f;
    
    _btnCancel.layer.borderWidth = 1.0f;
    _btnCancel.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    _btnCancel.layer.cornerRadius = 5.0f;
    
    _btnSave.layer.borderWidth = 1.0f;
    _btnSave.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    _btnSave.layer.cornerRadius = 5.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetCustomerListWithOpid:) name:@"finishGetCustomerListWithOpid" object:nil];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCustomerListWithOpid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissThisView
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)finishGetCustomerListWithOpid:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    _dataFiller = [resultArr copy];
    
    [_tbCustomerList reloadData];
}

- (void)SegmentControlIndexChanged:(UISegmentedControl *)segControl
{
//    switch (segControl.selectedSegmentIndex) {
//        case 0:
//            _dataFiller = @[@{@"name": @"Daw Aye", @"nrc": @"12/lmn(N)090909"},@{@"name": @"U Hla", @"nrc": @"12/MTN(N)090909"}];
//            break;
//            
//        case 1:
//            _dataFiller = @[@{@"name": @"U Bla Blah", @"nrc": @"12/dfe(N)324322"},@{@"name": @"U Aye", @"nrc": @"12/asd(N)243252"}];
//            break;
//            
//        case 2:
//            _dataFiller = @[@{@"name": @"Daw Hla", @"nrc": @"12/lmn(N)675432"},@{@"name": @"U Hla", @"nrc": @"12/MTN(N)33333"}, @{@"name": @"Daw Hla", @"nrc": @"12/lmn(N)56788"},@{@"name": @"U Hla", @"nrc": @"12/MTN(N)1234"}];
//            break;
//            
//        default:
//            break;
//    }
//    
//    [_tbCustomerList reloadData];
}

//- (void)addNewCustomer
//{
//    _viewUpper.hidden = NO;
//}

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

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"CustomerCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    Customer* cusobj = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = cusobj.name;
    cell.cellLblTotalSeat.text = cusobj.nrc_no;
    
    return cell;
}


- (IBAction)Cancel:(id)sender {
    _viewUpper.hidden = YES;
}

- (IBAction)Save:(id)sender {
    _txtName.text = @"";
    _txtNRC.text = @"";
}
@end
