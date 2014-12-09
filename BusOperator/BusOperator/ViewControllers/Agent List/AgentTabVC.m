//
//  AgentTabVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AgentTabVC.h"
#import "TripReportCell.h"
#import "DataFetcher.h"
#import "Agent.h"
#import "RadioButton.h"
#import "SelectAgentGroupVC.h"
#import "AgentGroup.h"
#import "JDStatusBarNotification.h"
#import "Reachability.h"

@interface AgentTabVC () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (strong, nonatomic) NSArray *dataFiller;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSString *commissionType;
@property (strong, nonatomic) NSArray *agentGroups;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSString* agentGpId;
@property (assign, nonatomic) BOOL isEditAgentClicked;
@property (assign, nonatomic) int editedAgentid;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tbAgentList;
@property (strong, nonatomic) IBOutlet UIView *viewUpper;
@property (strong, nonatomic) IBOutlet UIView *viewUpperContent;
@property (strong, nonatomic) IBOutlet UITextField *txtAgent;
@property (strong, nonatomic) IBOutlet UITextField *txtAgentNo;
@property (strong, nonatomic) IBOutlet UITextField *txtMaxSale;
@property (strong, nonatomic) IBOutlet UITextField *txtCommision;
@property (strong, nonatomic) IBOutlet UIButton *Cancel;
@property (strong, nonatomic) IBOutlet UIButton *Save;
@property (strong, nonatomic) IBOutlet UIButton *btnAgentGp;

- (IBAction)Cancel:(id)sender;
- (IBAction)Save:(id)sender;
- (IBAction)SelectAgentGroup:(id)sender;

@end

@implementation AgentTabVC

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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"ေရာင္းသူ အသစ္ထည့္ပါ" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 180, 40);
    [button addTarget:self action:@selector(addNewAgent) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
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
    
    _viewUpper.hidden = YES;
    _viewUpper.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _viewUpperContent.layer.cornerRadius = 5.0f;
    _viewUpperContent.layer.borderColor  = [[UIColor blackColor] CGColor];
    _viewUpperContent.layer.borderWidth = 3.0f;
    
    _Cancel.layer.borderWidth = 1.0f;
    _Cancel.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    _Cancel.layer.cornerRadius = 5.0f;
    
    _Save.layer.borderWidth = 1.0f;
    _Save.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    _Save.layer.cornerRadius = 5.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAgentDownload:) name:@"finishAgentDownload" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateAgent:) name:@"finishCreateAgent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAgentGroup:) name:@"finishAgentGroup" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAgentGp:) name:@"didSelectAgentGp" object:nil];
    
    _buttons = [NSMutableArray new];
    [self setRadioBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateAgent:) name:@"finishUpdateAgent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteAgent:) name:@"finishDeleteAgent" object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (!self.reachable) {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        
        NSDictionary* dict1 = @{@"name": @"City Mart", @"commission":@"10 %", @"maxsale":@"10000", @"number":@"0001"};
        NSDictionary* dict2 = @{@"name": @"Shwe", @"commission":@"50 %", @"maxsale":@"30000", @"number":@"0002"};
        NSDictionary* dict3 = @{@"name": @"Shwe Kyay Si", @"commission":@"70 %", @"maxsale":@"50000", @"number":@"0003"};
        
        _dataFiller = @[dict1, dict2, dict3];

    }
    else {
        [self JDStatusBarHidden:NO status:@"Retrieving..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAllAgents];
        [fetcher getAllAgentGroups];
    }

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

- (void)setupMMFont
{
    _txtAgent.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtAgentNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtCommision.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtMaxSale.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _btnAgentGp.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
}

- (void)setRadioBtn
{
	CGRect btnRect = CGRectMake(350, 140, 100, 30);
	for (NSString* optionTitle in @[@"%", @"Ks"]) {
		RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
		btnRect.origin.x += 102;
		[btn setTitle:optionTitle forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
		[btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [btn addTarget:self action:@selector(onRadioClick:) forControlEvents:UIControlEventTouchUpInside];
		[_viewUpperContent addSubview:btn];
		[_buttons addObject:btn];
	}
    
	[_buttons[0] setGroupButtons:_buttons]; // Setting buttons into the group
    
	[_buttons[0] setSelected:YES];
    _commissionType = @"%";
}

- (void)onRadioClick:(id)sender
{
    RadioButton *btnRadio = (RadioButton *)sender;
    _commissionType = btnRadio.titleLabel.text;
    
}

- (void)finishAgentDownload:(NSNotification *)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* temp = (NSArray *)noti.object;
    _dataFiller = [temp copy];
    [_tbAgentList reloadData];
}

- (void)finishCreateAgent:(NSNotification *)noti
{
    NSDictionary* dict = (NSDictionary*)noti.object;
    NSString* msg = dict[@"message"];
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    _txtAgent.text = @"";
    _txtAgentNo.text = @"";
    _txtCommision.text = @"";
    _txtMaxSale.text = @"";
    [_btnAgentGp setTitle:@"Select Agent Group" forState:UIControlStateNormal];
    
}

- (void)finishAgentGroup:(NSNotification*)noti
{
    NSArray* resultArr = (NSArray*)noti.object;
    _agentGroups = [resultArr copy];
}

- (void)didSelectAgentGp:(NSNotification*)noti
{
    if (self.reachable) {
        AgentGroup* agGp = (AgentGroup*)noti.object;
        
        [_btnAgentGp setTitle:agGp.name forState:UIControlStateNormal];
        _agentGpId = agGp.id;
        
        
    }
    else {
        NSString* str = (NSString*)noti.object;
        [_btnAgentGp setTitle:str forState:UIControlStateNormal];
        
    }
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)finishUpdateAgent:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    _viewUpper.hidden = YES;
    
    _txtAgent.text = @"";
    _txtAgentNo.text = @"";
    _txtCommision.text = @"";
    _txtMaxSale.text = @"";
    [_btnAgentGp setTitle:@"Select Agent Group" forState:UIControlStateNormal];
}

- (void)finishDeleteAgent:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
//    [self JDStatusBarHidden:NO status:@"Retrieving..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllAgents];
}

- (void)addNewAgent
{
    _viewUpper.hidden = NO;
    _isEditAgentClicked = NO;
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


#pragma mark - CELL METHODS

- (void)deleteAgent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    Agent* agent = _dataFiller[btn.tag];
    
    [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher deleteAgentWithid:agent.id];
    
//    [_dataFiller removeObjectAtIndex:btn.tag];
//    
//    [_tbEditTirp reloadData];
}

- (void)editAgent:(id)sender
{
    _viewUpper.hidden = NO;
    UIButton* btnEdit = (UIButton*)sender;
    
    if (self.reachable) {
        Agent* agent = _dataFiller[btnEdit.tag];
        
        _txtAgent.text = agent.name;
        _txtAgentNo.text = agent.phone;
        _txtMaxSale.text = agent.address;
        _txtCommision.text = [NSString stringWithFormat:@"%d",agent.commission];
        [_btnAgentGp setTitle:agent.agentgroup forState:UIControlStateNormal];
        
        if ([agent.commissiontype isEqualToString:@"Percentage"]) {
            [_buttons[0] setSelected:YES];
            _commissionType = @"%";
        }
        else {
            [_buttons[1] setSelected:YES];
            _commissionType = @"Ks";
        }
        
        _isEditAgentClicked = YES;
        _editedAgentid = agent.id;

    }
    else {
        NSDictionary* dict = _dataFiller[btnEdit.tag];
        _txtAgent.text = dict[@"name"];
        _txtAgentNo.text = @"0123456";
        _txtMaxSale.text = @"No.65, Lan Thit St., Lan Ma Taw Tsp., Yangon.";
        _txtCommision.text = dict[@"commission"];
        [_btnAgentGp setTitle:@"Agent Group 1" forState:UIControlStateNormal];
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
    NSString* cellid = @"AgentListCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        Agent* agent = _dataFiller[indexPath.row];
        cell.cellLblDate.text = agent.name;
        if ([agent.commissiontype isEqualToString:@"Percentage"]) {
            cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%d %%",agent.commission];
        }
        else {
            cell.cellLblTotalSeat.text = [NSString stringWithFormat:@"%d Ks",agent.commission];
        }
        
        cell.cellLblTotalSales.text = @"";
        cell.cellLblUnitPrice.text = [NSString stringWithFormat:@"%d",agent.id];

    }
    else {
        NSDictionary* dict = _dataFiller[indexPath.row];
        
        cell.cellLblDate.text = dict[@"name"];
        cell.cellLblTotalSeat.text = dict[@"commission"];
        cell.cellLblTotalSales.text = @"";
        cell.cellLblUnitPrice.text = dict[@"number"];
    }
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Delete" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(deleteAgent:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btnedit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnedit.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnedit.backgroundColor = [UIColor clearColor];
    [btnedit setTitle:@"Edit" forState:UIControlStateNormal];
    [btnedit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnedit addTarget:self action:@selector(editAgent:) forControlEvents:UIControlEventTouchUpInside];
    
    btnedit.tag = indexPath.row;
    [cell.cellBtnEditBkgView addSubview:btnedit];
    
    return cell;
}


- (IBAction)Cancel:(id)sender {
    _viewUpper.hidden = YES;
    _txtAgent.text = @"";
    _txtAgentNo.text = @"";
    _txtCommision.text = @"";
    _txtMaxSale.text = @"";
    [_btnAgentGp setTitle:@"Select Agent Group" forState:UIControlStateNormal];
    
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllAgents];
}

- (IBAction)Save:(id)sender {
    //Save
    
    if (self.reachable) {
        int comid;
        if ([_commissionType isEqualToString:@"%"]) {
            comid = 2;
        }
        else comid = 1;
        
        if (_txtCommision.text.length>0 && _txtAgent.text.length > 0 && _txtAgentNo.text.length > 0 && _txtMaxSale.text.length > 0 && ![_btnAgentGp.titleLabel.text isEqualToString:@"Select Agent Group"]) {
            
            [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
            DataFetcher* fetcher = [DataFetcher new];
            
            if (_isEditAgentClicked) {
                NSDictionary* dict = @{@"agentid": @(_editedAgentid),
                                       @"name": _txtAgent.text,
                                       @"ph": _txtAgentNo.text,
                                       @"address": _txtMaxSale.text,
                                       @"com": _txtCommision.text,
                                       @"comid": @(comid)};
                [fetcher updateAgentWithDictionary:dict];
            }
            else {
                [fetcher createNewAgentWithName:_txtAgent.text withPh:_txtAgentNo.text withAdd:_txtMaxSale.text withComid:comid withCommission:[_txtCommision.text intValue] withAgentgp:_agentGpId];
            }
            
        }
    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
    }
    
}

- (IBAction)SelectAgentGroup:(id)sender {
    SelectAgentGroupVC* cityvc = (SelectAgentGroupVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectAgentGroupVC"];
    _myPopoverController = [[UIPopoverController alloc] initWithContentViewController:cityvc];
    if (self.reachable) {
        cityvc.tripList = [_agentGroups copy];
    }
    [_myPopoverController presentPopoverFromRect:_btnAgentGp.frame inView:_viewUpperContent permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
@end
