//
//  InputCommissionVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "InputCommissionVC.h"
#import "RadioButton.h"
#import "SelectAgentGroupVC.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"

@interface InputCommissionVC ()

@property (strong, nonatomic) NSMutableArray* buttons;
@property (strong, nonatomic) NSArray* triplist;
@property (strong, nonatomic) UIPopoverController*myPopoverController;
@property (assign, nonatomic) int selectedtripid;
@property (assign, nonatomic) int comid;

@property (weak, nonatomic) IBOutlet UIView *upbgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnTrip;
@property (weak, nonatomic) IBOutlet UITextField *txtAmt;

- (IBAction)SelectTriplist:(id)sender;
- (IBAction)SaveCommission:(id)sender;
- (IBAction)Cancel:(id)sender;

@end

@implementation InputCommissionVC

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
    
    self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetTirpListCommission:) name:@"finishGetTirpListCommission" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAgentGp:) name:@"didSelectAgentGp" object:nil];
    
    DataFetcher* df = [DataFetcher new];
    [df getTriplistWithFromto];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPostAgentComm:) name:@"finishPostAgentComm" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _buttons = [[NSMutableArray alloc] init];
     [self setRadioBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectAgentGp:(NSNotification*)notification
{
    NSDictionary* dict = (NSDictionary*)notification.object;
    //com id = 1=> fix , 2 => %
    NSString* strtrip = [NSString stringWithFormat:@"%@-%@", dict[@"from_city"], dict[@"to_city"]];
    [_btnTrip setTitle:strtrip forState:UIControlStateNormal];
    
    _selectedtripid = [dict[@"id"] intValue];
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)finishPostAgentComm:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    //    if (self.reachable) {
//    if ([segue.identifier isEqualToString:@"agentpopover"]) {
        SelectAgentGroupVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
        triplistvc.isTripListShowing = YES;
        triplistvc.tripList = [_triplist copy];
        
//    }
    //    }
}


- (void)setRadioBtn
{
    
    
	CGRect btnRect = CGRectMake(10, 110, 200, 30);
	for (NSString* optionTitle in @[@"Percentage", @"Fix Amount"]) {
		RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
		btnRect.origin.x += 142;
		[btn setTitle:optionTitle forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont systemFontOfSize:17];
		[btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [btn addTarget:self action:@selector(onRadioClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.upbgView addSubview:btn];
		[_buttons addObject:btn];
	}
    
	[_buttons[0] setGroupButtons:_buttons]; // Setting buttons into the group
    
    [_buttons[0] setSelected:YES];
    _comid = 2;
    
}

- (void)onRadioClick:(id)sender {
    
    RadioButton *btnRadio = (RadioButton *)sender;
    
    if ([btnRadio.titleLabel.text isEqualToString:@"Percentage"]) _comid = 2;
    else _comid = 1;

    
}

- (void)finishGetTirpListCommission:(NSNotification*)notification
{
    NSDictionary* tempdict = (NSDictionary*)notification.object;
    NSArray* temparr = tempdict[@"trips"];
    NSLog(@"%@",temparr);
    _triplist = [temparr copy];
}


- (IBAction)SelectTriplist:(id)sender {
    
    
}

- (IBAction)SaveCommission:(id)sender {
    
    if (_selectedtripid != 0 && _txtAmt.text.length > 0) {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        NSDictionary* dict = @{@"tripid": @(_selectedtripid), @"commid": @(_comid), @"comm": _txtAmt.text, @"agentid": @(_agentid)};
        DataFetcher* df = [DataFetcher new];
        [df postAgentCommission:dict];
    }
    
}

- (IBAction)Cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
