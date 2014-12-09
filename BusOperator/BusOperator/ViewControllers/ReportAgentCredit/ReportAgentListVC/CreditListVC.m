//
//  CreditListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/21/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreditListVC.h"
#import "TripReportCell.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"
#import "City.h"
#import "TripListVC.h"
#import "TripTimeListVC.h"
#import "EditCreditListVC.h"
#import "MakePaymentVC.h"
#import "TransitionDelegate.h"

@interface CreditListVC ()

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;
@property (assign, nonatomic) BOOL isFromDate;
@property (assign, nonatomic) BOOL isFromCity;
@property (strong, nonatomic) City* currentFromCity;
@property (strong, nonatomic) City* currentToCity;
@property (strong, nonatomic) NSArray* timeStrArr;
@property (assign, nonatomic) long totalpayment;
@property (strong, nonatomic) NSMutableArray* paymentArr;
@property (strong, nonatomic) NSMutableArray* orderidArr;

@property (strong, nonatomic) UIPopoverController* myPopoverController;

@property (strong, nonatomic) NSArray* fromCityList;
@property (strong, nonatomic) NSArray* toCityList;

@property (strong, nonatomic) NSMutableArray* selectedarr;
@property (strong, nonatomic) TransitionDelegate* transitionController;

@property (weak, nonatomic) IBOutlet UITableView *tbCreditList;
@property (weak, nonatomic) IBOutlet UILabel *lblbuydat;
@property (weak, nonatomic) IBOutlet UILabel *lbltrip;
@property (weak, nonatomic) IBOutlet UILabel *lblvno;
@property (weak, nonatomic) IBOutlet UILabel *lblSeat;
@property (weak, nonatomic) IBOutlet UILabel *lblPayrate;
@property (weak, nonatomic) IBOutlet UILabel *lbltotal;
@property (weak, nonatomic) IBOutlet UIView *viewUpper;

@property (weak, nonatomic) IBOutlet UILabel *lblFromCity;
@property (weak, nonatomic) IBOutlet UIButton *btnFromCity;
@property (weak, nonatomic) IBOutlet UILabel *lblTocity;
@property (weak, nonatomic) IBOutlet UIButton *btnToCity;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UILabel *lblFromDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTodate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;


- (IBAction)Search:(id)sender;
- (IBAction)SelectFromDate:(id)sender;
- (IBAction)SelectToDate:(id)sender;
- (IBAction)SelectFromCity:(id)sender;
- (IBAction)SelectToCity:(id)sender;

@end

@implementation CreditListVC
@synthesize transitionController;

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
    
    _viewUpper.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(Add:)];
    
    transitionController = [[TransitionDelegate alloc] init];
    
    _lblFromCity.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblFromCity.text = @"ထြက္ခြာမည့္ျမိဳ ့ေရြးပါ";
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _lblTocity.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTocity.text = @"ေရာက္ရွိမည့္ျမိဳ ့ေရြးပါ";
    
    _lblFromDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblFromDate.text = @"အစေန ့ရက္ေရြးပါ";
    
    _lblTodate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTodate.text = @"အဆံုုးေန ့ရက္ေရြးပါ";
    
    _lblTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTime.text = @"အခ်ိန္ေရြးပါ";
    
    UIBarButtonItem *chkmanuaaly = [[UIBarButtonItem alloc]initWithTitle:@"  Search  " style:UIBarButtonItemStyleBordered target:self action:@selector(Add:)];
    UIBarButtonItem *makepayment = [[UIBarButtonItem alloc]initWithTitle:@"Make Payment" style:UIBarButtonItemStyleBordered target:self action:@selector(makepayment:)];
    self.navigationItem.rightBarButtonItems = @[chkmanuaaly, makepayment];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"CreditList" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateCreditList:) name:@"didSelectDateCreditList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCityListByAgentid:) name:@"finishCityListByAgentid" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityCreditList:) name:@"didSelectCityCreditList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownloadTimeWithAgentid:) name:@"finishDownloadTimeWithAgentid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTimeCreditList:) name:@"selectTimeCreditList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetCreditList:) name:@"finishGetCreditList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCreditList:) name:@"reloadCreditList" object:nil];
    
    if (self.reachable) {
//        [self JDStatusBarHidden:NO status:@"Retrieving..." duration:<#(NSTimeInterval)#>]
        DataFetcher* df = [DataFetcher new];
        [df getCitiesWithAgentid:_agentid];
        [df getTimeWithAgentid:_agentid];
    }
    
    _totalpayment = 0;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadCreditList:(NSNotification*)noti
{
    [self getCreditList];
}

- (void)nextview
{
//    EditCreditListVC* nextvc = (EditCreditListVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"EditCreditListVC"];
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    //
//    [self presentViewController:nextvc animated:YES completion:nil];
}

- (void)didSelectDateCreditList:(NSNotification*)notification
{
    NSString* strdate = (NSString*)notification.object;
    if (_isFromDate) [_btnFromDate setTitle:strdate forState:UIControlStateNormal];
    else [_btnToDate setTitle:strdate forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)finishCityListByAgentid:(NSNotification*)noti
{
    NSDictionary* tempDict = (NSDictionary*)noti.object;
    NSArray* fromArr = tempDict[@"fromCity"];
    _fromCityList = [fromArr copy];
    if (_fromCityList.count > 0) {
        City* fromcity = (City*)_fromCityList[0];
        [_btnFromCity setTitle:fromcity.name forState:UIControlStateNormal];
        _currentFromCity = fromcity;
    }
    
    NSArray* toArr = tempDict[@"toCity"];
    _toCityList = [toArr copy];
    if (_toCityList.count > 0) {
        City* fromcity = (City*)_toCityList[0];
        [_btnToCity setTitle:fromcity.name forState:UIControlStateNormal];
        _currentToCity = fromcity;
    }

    
}

- (void)finishDownloadTimeWithAgentid:(NSNotification*)noti
{
    _timeStrArr = (NSArray*)noti.object;
    [_btnTime setTitle:@"All" forState:UIControlStateNormal];
}

- (void)selectTimeCreditList:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnTime setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}


- (void)didSelectCityCreditList:(NSNotification*)notification
{
    if (self.reachable) {
        City* city = (City*)notification.object;
        if (_isFromCity) {
            [_btnFromCity setTitle:city.name forState:UIControlStateNormal];
            _currentFromCity = city;
        }
        else {
            [_btnToCity setTitle:city.name forState:UIControlStateNormal];
            _currentToCity = city;
        }
        
    }
    else {
        NSString* str = (NSString*)notification.object;
        if (_isFromCity) [_btnFromCity setTitle:str forState:UIControlStateNormal];
        
        else [_btnToCity setTitle:str forState:UIControlStateNormal];
        
    }
    
    [_myPopoverController dismissPopoverAnimated:YES];
    
}

- (void)finishGetCreditList:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* arr = (NSArray*)noti.object;
    _dataFiller = [arr copy];
    [_tbCreditList reloadData];
    _paymentArr = [[NSMutableArray alloc] initWithCapacity:_dataFiller.count];
    _orderidArr = [[NSMutableArray alloc] initWithCapacity:_dataFiller.count];
    
    _selectedarr = [[NSMutableArray alloc] initWithCapacity:_dataFiller.count];
    for (int i = 0; i < _dataFiller.count; i++) {
        [_selectedarr addObject:@"0"];
    }
}

- (void)Add:(id)sender
{
    if (_viewUpper.hidden) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_viewUpper.layer addAnimation:transition forKey:nil];
        
        _viewUpper.hidden = NO;
    }
    else {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_viewUpper.layer addAnimation:transition forKey:nil];
        _viewUpper.hidden = YES;
    }
    
//    [parentView addSubview:myVC.view];

}

- (void)makepayment:(id)sender
{
    MakePaymentVC* nextvc = (MakePaymentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"MakePaymentVC"];
    nextvc.prepaidamt = _prepaidamt;
    nextvc.totalpayment = _totalpayment;
    NSMutableString* mustr = [NSMutableString new];
    for (int i=0; i<_orderidArr.count; i++){
        
        if (i == _orderidArr.count-1) {
            [mustr appendFormat:@"%@",_orderidArr[i]];
        } else [mustr appendFormat:@"%@,",_orderidArr[i]];
    }
    nextvc.strorderid = mustr;
    nextvc.agentid = _agentid;
    
//    [NSUserDefaults standardUserDefaults] sta
    
    nextvc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    [nextvc setTransitioningDelegate:transitionController];
    nextvc.modalPresentationStyle= UIModalPresentationCustom;
    [self presentViewController:nextvc animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    if (self.reachable) {
        if ([segue.identifier isEqualToString:@"selectfromcity"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_fromCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"selecttocity"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_toCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"timepopover"])
        {
            TripTimeListVC* triptimelist = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triptimelist.tripList = [_timeStrArr mutableCopy];
        }

        
    }

}

- (void)viewDetail:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSDictionary* dict = _dataFiller[btn.tag];
    EditCreditListVC* nextvc = (EditCreditListVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"EditCreditListVC"];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    nextvc.order_id = dict[@"id"];
    //
    nextvc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    [nextvc setTransitioningDelegate:transitionController];
    nextvc.modalPresentationStyle= UIModalPresentationCustom;
    [self presentViewController:nextvc animated:YES completion:nil];
}

- (void)checkToPay:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSString* strselected = _selectedarr[btn.tag];
    int total = [_paymentArr[btn.tag] intValue];
//    _ischecked = !_ischecked;
    
    if ([strselected isEqualToString:@"0"]) {
        [btn setImage:[UIImage imageNamed:@"cb_glossy_on"] forState:UIControlStateNormal];
        NSDictionary* dict = _dataFiller[btn.tag];
        _totalpayment += total;
        [_orderidArr addObject:dict[@"id"]];
        [_selectedarr replaceObjectAtIndex:btn.tag withObject:@"1"];
    }
    else {
        [btn setImage:[UIImage imageNamed:@"cb_glossy_off"] forState:UIControlStateNormal];
        NSDictionary* dict = _dataFiller[btn.tag];
        [_orderidArr removeObject:dict[@"id"]];
        _totalpayment -= total;
        [_selectedarr replaceObjectAtIndex:btn.tag withObject:@"0"];
        
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
    NSString* cellid = @"creditlistcell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTextExtra.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    /*
     */
    
    if (self.reachable) {
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* tdate = [df dateFromString:dict[@"orderdate"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString* newstr = [df stringFromDate:tdate];

        cell.cellLblDate.text = newstr;
        
       
        cell.cellLblTotalSeat.text = dict[@"trip"];
        cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@",dict[@"total_ticket"]];
        int result = [dict[@"price"] intValue] - [dict[@"commission"] intValue];
        cell.cellLblUnitPrice.text = [NSString stringWithFormat:@"%d(%@)",result,dict[@"commission"]];
        int total = result*[dict[@"total_ticket"] intValue];
        cell.cellLblTextExtra.text = [NSString stringWithFormat:@"%d",total];
        [_paymentArr addObject:@(total)];
    }
    else {
        cell.cellLblDate.text = dict[@"date"];
        cell.cellLblTotalSeat.text = dict[@"totalSeat"];
        cell.cellLblTotalSales.text = dict[@"totalSale"];
    }
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"View Detail" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(viewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btnChkCell = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChkCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnEditBkgView.frame.size.width, cell.cellBtnEditBkgView.frame.size.height);
    //    btnCell.backgroundColor = [UIColor blueColor];
    //    [btnCell setTitle:@"Select it" forState:UIControlStateNormal];
    [btnChkCell setImage:[UIImage imageNamed:@"cb_glossy_off"] forState:UIControlStateNormal];
    [btnChkCell setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnChkCell addTarget:self action:@selector(checkToPay:) forControlEvents:UIControlEventTouchUpInside];
    
    btnChkCell.tag = indexPath.row;
    [cell.cellBtnEditBkgView addSubview:btnChkCell];
    
    return cell;
}

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

- (IBAction)Search:(id)sender {
    
    [self getCreditList];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_viewUpper.layer addAnimation:transition forKey:nil];
    _viewUpper.hidden = YES;
}

- (void)getCreditList
{
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    

    NSDictionary* dict = @{@"agentid": @(_agentid),
                           @"from": _currentFromCity.id,
                           @"to": _currentToCity.id,
                           @"startdate": _btnFromDate.titleLabel.text,
                           @"enddate": _btnToDate.titleLabel.text};
    DataFetcher* df = [DataFetcher new];
    [df getCreditList:dict];

}

- (IBAction)SelectFromDate:(id)sender {
    
    _isFromDate = YES;
}

- (IBAction)SelectToDate:(id)sender {
    _isFromDate = NO;
}

- (IBAction)SelectFromCity:(id)sender {
    
    _isFromCity = YES;
}

- (IBAction)SelectToCity:(id)sender {
    _isFromCity = NO;
}
@end
