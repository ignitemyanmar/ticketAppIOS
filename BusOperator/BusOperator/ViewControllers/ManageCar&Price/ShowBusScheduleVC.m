//
//  ShowBusScheduleVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/28/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ShowBusScheduleVC.h"
#import "TripReportCell.h"
#import "AddNewBusScheduleVC.h"
#import "ChooseBusClass.h"
#import "DataFetcher.h"
#import "ChooseCityVC.h"
#import "JDStatusBarNotification.h"
#import "City.h"
#import "BusClass.h"

@interface ShowBusScheduleVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataFiller;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSString *popovername;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) NSArray* fromCityList;
@property (strong, nonatomic) NSArray* toCityList;
@property (strong, nonatomic) City* fromCity;
@property (strong, nonatomic) City* toCity;
@property (strong, nonatomic) NSString* scheduleid;
@property (strong, nonatomic) NSArray* busclasses;
@property (strong, nonatomic) BusClass* mybusclass;

@property (strong, nonatomic) IBOutlet UITableView *tbBusSchedule;
@property (strong, nonatomic) IBOutlet UIButton *btnFromCity;
@property (strong, nonatomic) IBOutlet UIButton *btnToCity;
@property (strong, nonatomic) IBOutlet UIButton *btnFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnToDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEditTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblEditdate;
@property (strong, nonatomic) IBOutlet UILabel *lblEditTime;
@property (strong, nonatomic) IBOutlet UITextField *txtEditBusNo;
@property (strong, nonatomic) IBOutlet UIButton *btnEditBusClass;

@property (strong, nonatomic) IBOutlet UIView *viewEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnEditCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnEditSave;
@property (strong, nonatomic) IBOutlet UIView *upperBkgView;
@property (strong, nonatomic) IBOutlet UIView *uppercontentView;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleBusClass;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleBusNo;

- (IBAction)Search:(id)sender;
- (IBAction)onBtnFromCityClick:(id)sender;
- (IBAction)onBtnToCityClick:(id)sender;
- (IBAction)onBtnFromDateClick:(id)sender;
- (IBAction)onBtnToDateClick:(id)sender;
- (IBAction)onEditSelectBusClass:(id)sender;
- (IBAction)CancelEditView:(id)sender;
- (IBAction)SaveEdit:(id)sender;


@end

@implementation ShowBusScheduleVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCity:) name:@"didSelectCity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateFromShowBusSchedule:) name:@"didSelectDateFromShowBusSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectClassFromShowBusShedule:) name:@"didSelectClassFromShowBusShedule" object:nil];
    
    
    _viewEdit.hidden = YES;
    _btnEditCancel.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    _btnEditCancel.layer.borderWidth = 1.0f;
    _btnEditCancel.layer.cornerRadius = 5.0f;
    
    _btnEditSave.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    _btnEditSave.layer.borderWidth = 1.0f;
    _btnEditSave.layer.cornerRadius = 5.0f;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"ShowBusSchedule" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllCityDownloadFromShowBusSchedule:) name:@"finishAllCityDownloadFromShowBusSchedule" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishgetbusclassess:) name:@"finishgetbusclassess" object:nil];
    
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCitiesWithOpid];
    [fetcher getAllBusClasses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishgetBusSchedule:) name:@"finishgetBusSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishupdateBusSchedule:) name:@"finishupdateBusSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteBusSchedule:) name:@"finishDeleteBusSchedule" object:nil];
    
    _btnFromCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnFromCity setTitle:@"ခရီးစဥ္အစ ေရြးပါ" forState:UIControlStateNormal];
    
    _btnToCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnToCity setTitle:@"ခရီးစဥ္အဆံုုး  ေရြးပါ" forState:UIControlStateNormal];
    
    _btnFromDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnFromDate setTitle:@"ေန ့ရက္ ေရြးပါ" forState:UIControlStateNormal];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _lblTitleTime.text = @"ကားထြက္ခိ်န္";
    _lblTitleTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblTitleBusClass.text = @"ကားအမ်ိဴးအစား";
    _lblTitleBusClass.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblTitleBusNo.text = @"ကားနံပါတ္";
    _lblTitleBusNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    _viewEdit.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _upperBkgView.layer.cornerRadius = 5.0f;
    _uppercontentView.layer.cornerRadius = 5.0f;
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

- (void)finishgetBusSchedule:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    
    [_tbBusSchedule reloadData];
}

- (void)finishupdateBusSchedule:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    _viewEdit.hidden = YES;
}

- (void)finishDeleteBusSchedule:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
//    [self JDStatusBarHidden:NO status:msg duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    NSDictionary* dict = @{@"date": _btnFromDate.titleLabel.text,
                           @"from": _fromCity.id,
                           @"to": _toCity.id};
    [fetcher getBusSchedule:dict];
}

- (void)finishgetbusclassess:(NSNotification*)noti
{
    
    NSArray* resultArr = (NSArray*)noti.object;
    _busclasses = [resultArr copy];

}

- (void)finishAllCityDownloadFromShowBusSchedule:(NSNotification*)noti
{
    NSDictionary* tempDict = (NSDictionary*)noti.object;
    NSArray* fromArr = tempDict[@"fromCity"];
    _fromCityList = [fromArr copy];
    NSArray* toArr = tempDict[@"toCity"];
    _toCityList = [toArr copy];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    if ([segue.identifier isEqualToString:@"selectfromcitysegue"]) {
        
        ChooseCityVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
        triplistvc.tripList = [_fromCityList copy];
    }
    else if ([segue.identifier isEqualToString:@"selecttocitysegue"]) {
        ChooseCityVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
        triplistvc.tripList = [_toCityList copy];
    }
    else if ([segue.identifier isEqualToString:@"busclasssegue"]) {
         ChooseBusClass *viewController = [(UIStoryboardPopoverSegue *)segue destinationViewController];
        viewController.tripList = [_busclasses copy];
    }
}


- (void)didSelectCity:(NSNotification *)notification
{
    City* city = (City*)notification.object;
    if ([_popovername isEqualToString:@"FromCity"]) {
        [_btnFromCity setTitle:city.name forState:UIControlStateNormal];
        _fromCity = city;
    }
    else if ([_popovername isEqualToString:@"ToCity"]){
        [_btnToCity setTitle:city.name forState:UIControlStateNormal];
        _toCity = city;
    }
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectDateFromShowBusSchedule:(NSNotification *) notification
{
    NSString* str = (NSString*)notification.object;
    if ([_popovername isEqualToString:@"FromDate"]) {
        [_btnFromDate setTitle:str forState:UIControlStateNormal];
    }
    else if ([_popovername isEqualToString:@"ToDate"]) {
        [_btnToDate setTitle:str forState:UIControlStateNormal];
    }
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectClassFromShowBusShedule:(NSNotification *)notification
{
    BusClass* busclass = (BusClass*)notification.object;
    [_btnEditBusClass setTitle:busclass.name forState:UIControlStateNormal];
    _mybusclass = busclass;
    [_myPopoverController dismissPopoverAnimated:YES];
}

//- (void)addBusSchedule
//{
//    AddNewBusScheduleVC *addschedulevc = (AddNewBusScheduleVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewBusScheduleVC"];
//    [self.navigationController pushViewController:addschedulevc animated:YES];
//}


- (void)myAction:(id)sender event:(id)event
{
    /*
     {
     "id": "113",
     "bus_no": "YGN-9898",
     "class_id":"15",
     "class": "VIP",
     "departure_time": "07:30 PM",
     "sold_seats": 5,
     "total_seats": 33,
     "total_amount": 75000
     }
     */
    _viewEdit.hidden = NO;
    UIButton * btn = (UIButton *)sender;
    NSDictionary *dict = _dataFiller[btn.tag];
    _txtEditBusNo.text = dict[@"bus_no"];
    [_btnEditBusClass setTitle:dict[@"class"] forState:UIControlStateNormal];
    _lblEditTripName.text = [NSString stringWithFormat:@"%@ - %@",_btnFromCity.titleLabel.text,_btnToCity.titleLabel.text];
//    _lblEditdate.text = dict[@"date"];
    _lblEditTime.text = dict[@"departure_time"];
    _scheduleid = dict[@"id"];
    
    int opid = [[NSUserDefaults standardUserDefaults] integerForKey:@"opid"];
    NSDictionary* dictbusclass = @{@"id": dict[@"class_id"],
                                   @"name" : dict[@"class"],
                                   @"operator_id" : @(opid)};
    BusClass* busclassobj = [[BusClass alloc] initWithDictionary:dictbusclass error:nil];
    _mybusclass = busclassobj;
    
}

- (void)delete:(id)sender event:(id)event {
    UIButton * btn = (UIButton *)sender;
    NSDictionary *dict = _dataFiller[btn.tag];
    _scheduleid = dict[@"id"];
    [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher deleteBusScheduleWithid:_scheduleid];
    
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



#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"allbustimecell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    /*
    {
     "id": "113",
     "bus_no": "YGN-9898",
     "class_id":"15",
     "class": "VIP",
     "departure_time": "07:30 PM",
     "sold_seats": 5,
     "total_seats": 33,
     "total_amount": 75000
    }
    */
//    cell.cellLblDate.text = dict[@"date"];
    cell.cellLblTotalSeat.text = dict[@"departure_time"];
    cell.cellLblTotalSales.text = dict[@"class"];
    cell.cellLblUnitPrice.text = dict[@"bus_no"];
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Edit" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(myAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btndelete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btndelete.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnHolidayBkgView.frame.size.width, cell.cellBtnHolidayBkgView.frame.size.height);
    btndelete.backgroundColor = [UIColor clearColor];
    [btndelete setTitle:@"Delete" forState:UIControlStateNormal];
    [btndelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btndelete addTarget:self action:@selector(delete:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btndelete.tag = indexPath.row;
    [cell.cellBtnHolidayBkgView addSubview:btndelete];
    
    return cell;
}


- (IBAction)Search:(id)sender
{
    if (![_btnFromDate.titleLabel.text isEqualToString:@"ေန ့ရက္ ေရြးပါ"] && _fromCity && _toCity) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        NSDictionary* dict = @{@"date": _btnFromDate.titleLabel.text,
                               @"from": _fromCity.id,
                               @"to": _toCity.id};
        [fetcher getBusSchedule:dict];
    }
    
}

- (IBAction)onBtnFromCityClick:(id)sender {
    _popovername = @"FromCity";
}

- (IBAction)onBtnToCityClick:(id)sender {
    _popovername = @"ToCity";
}

- (IBAction)onBtnFromDateClick:(id)sender {
    _popovername = @"FromDate";
}

- (IBAction)onBtnToDateClick:(id)sender {
    _popovername = @"ToDate";
}

- (IBAction)onEditSelectBusClass:(id)sender {
    
    //
//    UIButton *myBtn = (UIButton *)sender;
//    ChooseBusClass *viewController = (ChooseBusClass*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseBusClass"];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    _popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
//    //    popover.delegate = self;
//    //    popover.popoverContentSize = CGSizeMake(644, 425); //your custom size.
//    [_popover presentPopoverFromRect:_btnEditBusClass.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)CancelEditView:(id)sender {
    _viewEdit.hidden = YES;
}

- (IBAction)SaveEdit:(id)sender {
    //Save Edited Data
    
    
    
    [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
    NSLog(@"scheduleid : %@, busno : %@, classid : %@",_scheduleid, _txtEditBusNo.text,_mybusclass.id);
    DataFetcher* fetcher = [DataFetcher new];
    NSDictionary* dict = @{@"scheduleid": _scheduleid,
                           @"busno": _txtEditBusNo.text,
                           @"classid": _mybusclass.id};
    [fetcher updateBusSchedule:dict];
    
}

@end
