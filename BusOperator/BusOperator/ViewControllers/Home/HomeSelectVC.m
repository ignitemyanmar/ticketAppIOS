//
//  HomeSelectVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "HomeSelectVC.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "AgentSelectVC.h"
#import "TripReportVC.h"
#import "SeatOccupacyReportVC.h"
#import "AddBusScheduleVC.h"
#import "CheckBusScheduleVC.h"
#import "DepartureReportWithTimeVC.h"
#import "AdvancedReportVC.h"
#import "DailySaleReportVC.h"
#import "DepartureBusReportVC.h"
#import "HotSaleTripReportVC.h"
#import "HotSaleAgentReportVC.h"
#import "HotSaleTypeReportVC.h"
#import "CreditAgentListVC.h"

@interface HomeSelectVC ()

@property (strong, nonatomic) UIPopoverController *mypopovervc;
@property (strong, nonatomic) IBOutlet UIView *bkgView;

@property (strong, nonatomic) IBOutlet UIButton *btnDepartureReport;
@property (strong, nonatomic) IBOutlet UIButton *btnDailyReport;
@property (strong, nonatomic) IBOutlet UIButton *btnTripReport;
@property (strong, nonatomic) IBOutlet UIButton *btnAgentReport;
@property (strong, nonatomic) IBOutlet UIButton *btnSeatOccupacyReport;
@property (weak, nonatomic) IBOutlet UIButton *btnHotSaleTrip;
@property (weak, nonatomic) IBOutlet UIButton *btnHotSaleAgent;
@property (weak, nonatomic) IBOutlet UIButton *btnHotSaleBusType;

- (IBAction)reportByTrips:(id)sender;
- (IBAction)reportByAgents:(id)sender;
- (IBAction)reportBySeatOccupacy:(id)sender;
- (IBAction)addBusSchedule:(id)sender;
- (IBAction)DepartureReport:(id)sender;
- (IBAction)GoToHotTripSaleReport:(id)sender;
- (IBAction)GoToDailyReport:(id)sender;
- (IBAction)GoToHotAgentSaleReport:(id)sender;
- (IBAction)GoToHotBusTypeSaleReport:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *GoToAgentCreditList;
- (IBAction)GotoAgentCreditlist:(id)sender;


@end

@implementation HomeSelectVC

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
    
//    self.title = @"Home";
    
    self.navigationItem.hidesBackButton = YES;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAddBusSchedule:) name:@"didSelectAddBusSchedule" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCheckBusSchedule:) name:@"didSelectCheckBusSchedule" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDailySaleReport:) name:@"didSelectDailySaleReport" object:nil];
    
    _btnDepartureReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnDepartureReport setTitle:@"ကားခ်ဳပ္ စာရင္းမ်ား" forState:UIControlStateNormal];
    
    _btnTripReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnTripReport setTitle:@"ခရီးစဥ္အလုုိက္ အေရာင္း ရွာရန္" forState:UIControlStateNormal];
    
    _btnAgentReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnAgentReport setTitle:@"အေရာင္းကိုုယ္စားလွယ္ႏွင့္အေရာင္းစာရင္းမ်ား" forState:UIControlStateNormal];
    
    _btnSeatOccupacyReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSeatOccupacyReport setTitle:@"ထိုုင္ခံုုႏွင့္လူစာရင္းမ်ား" forState:UIControlStateNormal];
    
    _btnDailyReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnDailyReport setTitle:@"ေန ့စဥ္ အေရာင္းစာရင္းမ်ား" forState:UIControlStateNormal];
    
    _btnHotSaleTrip.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnHotSaleTrip setTitle:@"အေရာင္းရဆံုုးခရီးစဥ္စာရင္းမ်ား" forState:UIControlStateNormal];
    
    _btnHotSaleAgent.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnHotSaleAgent setTitle:@"အေရာင္းရဆံုုး အေရာင္းကိုုယ္စားလွယ္ စာရင္းမ်ား" forState:UIControlStateNormal];
    
    _btnHotSaleBusType.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnHotSaleBusType setTitle:@"အေရာင္းရဆံုုး ကားအမ်ိဴးအစား စာရင္းမ်ား" forState:UIControlStateNormal];
    
    _GoToAgentCreditList.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_GoToAgentCreditList setTitle:@"အေရာင္းကိုုယ္စားလွယ္ႏွင့္အေၾကြးစာရင္း" forState:UIControlStateNormal];
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

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _mypopovervc = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (void)didSelectAddBusSchedule:(NSNotification*)notification
{
    [_mypopovervc dismissPopoverAnimated:YES];
    UIStoryboard* seatSB = [UIStoryboard getDailyReportStoryboard];
    DepartureReportWithTimeVC* seatvc = (DepartureReportWithTimeVC*)[seatSB instantiateViewControllerWithIdentifier:@"DepartureReportWithTimeVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
    
}

- (void)didSelectCheckBusSchedule:(NSNotification*)notification
{
    [_mypopovervc dismissPopoverAnimated:YES];
    UIStoryboard* seatSB = [UIStoryboard getDailyReportStoryboard];
    AdvancedReportVC* seatvc = (AdvancedReportVC*)[seatSB instantiateViewControllerWithIdentifier:@"AdvancedReportVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}

- (void)didSelectDailySaleReport:(NSNotification*)notification
{
    [_mypopovervc dismissPopoverAnimated:YES];
    UIStoryboard* seatSB = [UIStoryboard getDailyReportStoryboard];
    DailySaleReportVC* seatvc = (DailySaleReportVC*)[seatSB instantiateViewControllerWithIdentifier:@"DailySaleReportVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}

- (IBAction)reportByTrips:(id)sender {
    
    UIStoryboard* tripSB = [UIStoryboard getTripsStoryboard];
    TripReportVC* tripvc = (TripReportVC*)[tripSB instantiateViewControllerWithIdentifier:@"TripReportVC"];
    [self.navigationController pushViewController:tripvc animated:YES];
}

- (IBAction)reportByAgents:(id)sender {
    
    UIStoryboard* agentSB = [UIStoryboard getAgentsStoryboard];
    AgentSelectVC* agentvc = (AgentSelectVC*)[agentSB instantiateViewControllerWithIdentifier:@"AgentSelectVC"];
    [self.navigationController pushViewController:agentvc animated:YES];
}

- (IBAction)reportBySeatOccupacy:(id)sender {
    
    UIStoryboard* seatSB = [UIStoryboard getSeatOccupacyStoryboard];
    SeatOccupacyReportVC* seatvc = (SeatOccupacyReportVC*)[seatSB instantiateViewControllerWithIdentifier:@"SeatOccupacyReportVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}

- (IBAction)addBusSchedule:(id)sender {
    
}

- (IBAction)DepartureReport:(id)sender {
    
    UIStoryboard* seatSB = [UIStoryboard getDepartureReportStoryboard];
    DepartureBusReportVC* departurereportvc = (DepartureBusReportVC*)[seatSB instantiateViewControllerWithIdentifier:@"DepartureBusReportVC"];
    [self.navigationController pushViewController:departurereportvc animated:YES];
}

- (IBAction)GoToHotTripSaleReport:(id)sender {
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"HotSaleTrip" bundle:nil];
    HotSaleTripReportVC* nexvc = (HotSaleTripReportVC*)[sb instantiateViewControllerWithIdentifier:@"HotSaleTripReportVC"];
    [self.navigationController pushViewController:nexvc animated:YES];
    
}

- (IBAction)GoToDailyReport:(id)sender {
    UIStoryboard* seatSB = [UIStoryboard getDailyReportStoryboard];
    DailySaleReportVC* seatvc = (DailySaleReportVC*)[seatSB instantiateViewControllerWithIdentifier:@"DailySaleReportVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}

- (IBAction)GoToHotAgentSaleReport:(id)sender {
    //
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"HotSaleAgent" bundle:nil];
    HotSaleAgentReportVC* seatvc = (HotSaleAgentReportVC*)[sb instantiateViewControllerWithIdentifier:@"HotSaleAgentReportVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}

- (IBAction)GoToHotBusTypeSaleReport:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"HotSaleType" bundle:nil];
    HotSaleTypeReportVC* seatvc = (HotSaleTypeReportVC*)[sb instantiateViewControllerWithIdentifier:@"HotSaleTypeReportVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}
- (IBAction)GotoAgentCreditlist:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"ReportAgentCredit" bundle:nil];
    CreditAgentListVC* seatvc = (CreditAgentListVC*)[sb instantiateViewControllerWithIdentifier:@"CreditAgentListVC"];
    [self.navigationController pushViewController:seatvc animated:YES];
}
@end
