//
//  ChangeBusGateVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/24/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ChangeBusGateVC.h"
#import "DataFetcher.h"
#import "AgentListPopOver.h"
#import "JDStatusBarNotification.h"

@interface ChangeBusGateVC ()

@property (strong, nonatomic) NSArray* agentlist;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (assign, nonatomic) int selectedagentid;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectBusGate;
@property (weak, nonatomic) IBOutlet UIButton *btnQuit;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeBusGate;
- (IBAction)Quit:(id)sender;
- (IBAction)ChangeBusGate:(id)sender;


@end

@implementation ChangeBusGateVC

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
    
    _lblTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    _lblTitle.text = @"ကားဂိတ္ အမည္ခိ်န္္းရန္";
    
    _btnQuit.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    [_btnQuit setTitle:@"ထြက္မည္" forState:UIControlStateNormal];
    
    _btnChangeBusGate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    [_btnChangeBusGate setTitle:@"ဂိတ္ခြဲ ခ်ိန္းရန္" forState:UIControlStateNormal];
    
    _btnSelectBusGate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    [_btnSelectBusGate setTitle:@"ဂိတ္ခြဲ ေရြးပါ" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReportAgentListByOpid:) name:@"finishReportAgentListByOpid" object:nil];
    
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getReportAgentListByOpid:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAgentChangeGate:) name:@"didSelectAgentChangeGate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPostChangeBusGate:) name:@"finishPostChangeBusGate" object:nil];
    
    _selectedagentid = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishReportAgentListByOpid:(NSNotification*)noti
{
//    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _agentlist = [tempArr copy];
    if (tempArr.count > 0) {
        NSDictionary* dict = tempArr[0];
        [_btnSelectBusGate setTitle:dict[@"name"] forState:UIControlStateNormal];

    }
}

- (void)didSelectAgentChangeGate:(NSNotification*)noti
{
    NSDictionary* dict = (NSDictionary*)noti.object;
    _selectedagentid = [dict[@"id"] intValue];
    [_btnSelectBusGate setTitle:dict[@"name"] forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)finishPostChangeBusGate:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    [self Quit:nil];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    AgentListPopOver* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
    triplistvc.tripList = [_agentlist copy];
}

- (IBAction)Quit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissallview" object:nil];
    }];
}

- (IBAction)ChangeBusGate:(id)sender {
    if (_selectedagentid != 0) {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        NSDictionary* dict = @{@"orderid": _order_id, @"agentid": @(_selectedagentid)};
        DataFetcher* df = [DataFetcher new];
        [df postChangeBusGate:dict];
    }
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

@end
