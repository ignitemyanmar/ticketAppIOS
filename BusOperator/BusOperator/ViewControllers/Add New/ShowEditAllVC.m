//
//  ShowEditAllVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/18/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ShowEditAllVC.h"
#import "TripReportCell.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"
#import "City.h"
#import "AgentGroup.h"
#import "BusClass.h"
#import "CommissionType.h"

@interface ShowEditAllVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) NSString* editid;

@property (strong, nonatomic) IBOutlet UITableView *tbShowEditAll;
@property (strong, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) IBOutlet UIView *addnewView;
@property (strong, nonatomic) IBOutlet UITextField *txtAddNewCity;
@property (strong, nonatomic) IBOutlet UILabel *lblCityName;
@property (strong, nonatomic) IBOutlet UITextField *txtNewCityName;
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEditTitle;

- (IBAction)SaveNewCity:(id)sender;
- (IBAction)CancelSaving:(id)sender;
- (IBAction)UpdateCity:(id)sender;


@end

@implementation ShowEditAllVC

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
    
    [button setTitle:@"အသစ္ထည့္ပါ" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [button setBackgroundColor:[UIColor colorWithRed:116.0f/255 green:206.0f/255 blue:113.0f/255 alpha:1]];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(addNewCity) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"showedetailvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
    
    _upperView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"showeditallvc" forKey:@"currentvc"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _upperView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _addnewView.layer.cornerRadius = 5.0f;
    _addnewView.layer.borderColor = [[UIColor blackColor] CGColor];
    _addnewView.layer.borderWidth = 3.0f;
    
    _txtAddNewCity.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtNewCityName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblCityName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if ([_previousvc isEqualToString:@"city"]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllCityDownload:) name:@"finishAllCityDownload" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNewCityCreate:) name:@"finishNewCityCreate" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateCity:) name:@"finishUpdateCity" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteCity:) name:@"finishDeleteCity" object:nil];
        
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAllCities];
        
    }
    else if ([_previousvc isEqualToString:@"agentgroup"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAllAgentGroupDownload:) name:@"finishAllAgentGroupDownload" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNewAgentGroupCreate:) name:@"finishNewAgentGroupCreate" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateAgentgroup:) name:@"finishUpdateAgentgroup" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteAgentGroup:) name:@"finishDeleteAgentGroup" object:nil];
        
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAllAgentGroups];
        
    }
    else if ([_previousvc isEqualToString:@"bustype"]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetAllBusType:) name:@"finishGetAllBusType" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNewBusTypeCreate:) name:@"finishNewBusTypeCreate" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateBusType:) name:@"finishUpdateBusType" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteBusType:) name:@"finishDeleteBusType" object:nil];
        
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAllBusClasses];
        
    }
    else if ([_previousvc isEqualToString:@"tickettype"]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetAllTickettype:) name:@"finishGetAllTickettype" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateTicketType:) name:@"finishUpdateTicketType" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateNewTicketType:) name:@"finishCreateNewTicketType" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteTicketType:) name:@"finishDeleteTicketType" object:nil];
        
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getTicketTypeList];
    }
    else if ([_previousvc isEqualToString:@"commissiontype"]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetCommissionType:) name:@"finishGetCommissionType" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateCommissiontype:) name:@"finishCreateCommissiontype" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateCommissiontype:) name:@"finishUpdateCommissiontype" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteCommissiontype:) name:@"finishDeleteCommissiontype" object:nil];
        
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getCommissionType];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewCity
{
    _upperView.hidden = NO;
    _addnewView.hidden = NO;
    _editView.hidden = YES;
    
    if ([_previousvc isEqualToString:@"agentgroup"]) {
        _lblTitle.text = @"Add New Agent Group";
        _txtAddNewCity.placeholder = @"Enter Agent Group";
    }
    else if ([_previousvc isEqualToString:@"bustype"]) {
        _lblTitle.text = @"Add New Bus Type";
        _txtAddNewCity.placeholder = @"Enter Bus Type";
    }
    else if ([_previousvc isEqualToString:@"tickettype"]) {
        _lblTitle.text = @"Add New Ticket Type";
        _txtAddNewCity.placeholder = @"Enter Ticket Type";
    }
    else if ([_previousvc isEqualToString:@"commissiontype"]) {
        _lblTitle.text = @"Add New Commission Type";
        _txtAddNewCity.placeholder = @"Enter Commission Type";
    }
}

- (void)finishUpdateCity:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    _upperView.hidden = YES;
    _txtNewCityName.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllCities];

}

- (void)finishAllCityDownload:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    _dataFiller = [resultArr copy];
    [_tbShowEditAll reloadData];
}

- (void)finishAllAgentGroupDownload:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    _dataFiller = [resultArr copy];
    [_tbShowEditAll reloadData];

}

- (void)finishGetAllTickettype:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    _dataFiller = [resultArr copy];
    [_tbShowEditAll reloadData];

}

- (void)finishUpdateAgentgroup:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    _upperView.hidden = YES;
    _txtNewCityName.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllAgentGroups];

}

- (void)finishGetAllBusType:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* resultArr = (NSArray*)noti.object;
    _dataFiller = [resultArr copy];
    [_tbShowEditAll reloadData];

}

- (void)finishUpdateBusType:(NSNotification*)noti
{
//    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:YES status:@"" duration:0];
    
    _upperView.hidden = YES;
    _txtNewCityName.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllBusClasses];
}

- (void)finishUpdateTicketType:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    _upperView.hidden = YES;
    _txtNewCityName.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getTicketTypeList];

}

- (void)finishGetCommissionType:(NSNotification*)noti
{
    NSArray* temparr = (NSArray*) noti.object;
    _dataFiller = [temparr copy];
    
    [_tbShowEditAll reloadData];
}

- (void)finishUpdateCommissiontype:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:msg duration:3];
    
    _upperView.hidden = YES;
    _txtNewCityName.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCommissionType];
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


- (void)deleteCity:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    DataFetcher* fetcher = [DataFetcher new];
    if ([_previousvc isEqualToString:@"city"]) {
        City* cityObj = _dataFiller[btn.tag];
        [fetcher deleteCityWithid:cityObj.id];
    }
    else if ([_previousvc isEqualToString:@"agentgroup"]) {
        [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
        AgentGroup* cityObj = _dataFiller[btn.tag];
        [fetcher deleteAgentGroupWithid:cityObj.id];
    }
    else if ([_previousvc isEqualToString:@"bustype"]) {
        [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
        BusClass* cityObj = _dataFiller[btn.tag];
        [fetcher deleteBusTypeWithid:cityObj.id];
    }
    else if ([_previousvc isEqualToString:@"tickettype"]) {
        [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
        NSDictionary* dict = _dataFiller[btn.tag];
        [fetcher deleteTicketTypeWithid:dict[@"id"]];
    }
    else if ([_previousvc isEqualToString:@"commissiontype"]) {
        [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
        CommissionType* comtype = _dataFiller[btn.tag];
        [fetcher deleteCommissionTypeWithid:comtype.id];
    }
}

- (void)editCity:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if ([_previousvc isEqualToString:@"city"]) {
        City* cityObj = _dataFiller[btn.tag];
        _editid = cityObj.id;
        _lblCityName.text = cityObj.name;

    }
    else if ([_previousvc isEqualToString:@"agentgroup"]) {
        AgentGroup* cityObj = _dataFiller[btn.tag];
        _editid = cityObj.id;
        _lblCityName.text = cityObj.name;
        _lblEditTitle.text = @"Edit Agent Group";
        _txtNewCityName.placeholder = @"Enter New Agent Group";
    }
    
    else if ([_previousvc isEqualToString:@"bustype"]) {
        BusClass* cityObj = _dataFiller[btn.tag];
        _editid = cityObj.id;
        _lblCityName.text = cityObj.name;
        _lblEditTitle.text = @"Edit Bus Type";
        _txtNewCityName.placeholder = @"Enter New Bus Type";
    }
    else if ([_previousvc isEqualToString:@"tickettype"]) {
        NSDictionary* dict = _dataFiller[btn.tag];
        _editid = dict[@"id"];
        _lblCityName.text = dict[@"name"];
        _lblEditTitle.text = @"Edit Ticket Type";
        _txtNewCityName.placeholder = @"Enter New Ticket Type";
    }
    else if ([_previousvc isEqualToString:@"commissiontype"]) {
        
        CommissionType* comtype = _dataFiller[btn.tag];
        _editid = comtype.id;
        _lblCityName.text = comtype.commissiontype;
        _lblEditTitle.text = @"Edit Commission Type";
        _txtNewCityName.placeholder = @"Enter New Commission Type";
    }
    
    _upperView.hidden = NO;
    _addnewView.hidden = YES;
    _editView.hidden = NO;
    
}

- (void)finishNewCityCreate:(NSNotification*)noti
{
    //    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    _txtAddNewCity.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllCities];
}

- (void)finishNewAgentGroupCreate:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    _txtAddNewCity.text = @"";

    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllAgentGroups];
}

- (void)finishNewBusTypeCreate:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    _txtAddNewCity.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllBusClasses];
}

- (void)finishCreateNewTicketType:(NSNotification*)noti
{
    NSString* str = (NSString*) noti.object;
    [self JDStatusBarHidden:NO status:str duration:5];
    _txtAddNewCity.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getTicketTypeList];
}

- (void)finishCreateCommissiontype:(NSNotification*)noti
{
    NSString* str = (NSString*) noti.object;
    [self JDStatusBarHidden:NO status:str duration:5];
    _txtAddNewCity.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCommissionType];
}

- (void)finishDeleteAgentGroup:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllAgentGroups];
    
}

- (void)finishDeleteCity:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllCities];

}

- (void)finishDeleteBusType:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllBusClasses];
}

- (void)finishDeleteTicketType:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getTicketTypeList];
}

- (void)finishDeleteCommissiontype:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getCommissionType];

}

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"showeditCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if ([_previousvc isEqualToString:@"city"]) {
        City* cityObj = _dataFiller[indexPath.row];
        
        cell.cellLblDate.text = cityObj.name;
    }
    else if ([_previousvc isEqualToString:@"agentgroup"]) {
        AgentGroup* agentgroup = _dataFiller[indexPath.row];
        cell.cellLblDate.text = agentgroup.name;
    }
    else if ([_previousvc isEqualToString:@"bustype"]) {
        BusClass* bustype = _dataFiller[indexPath.row];
        cell.cellLblDate.text = bustype.name;
    }
    else if ([_previousvc isEqualToString:@"tickettype"]) {
        NSDictionary* dict = _dataFiller[indexPath.row];
        cell.cellLblDate.text = dict[@"name"];
    }
    else if ([_previousvc isEqualToString:@"commissiontype"]) {
        CommissionType* comtype = _dataFiller[indexPath.row];
        cell.cellLblDate.text = comtype.commissiontype;
    }
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Delete" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(deleteCity:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btnedit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnedit.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnedit.backgroundColor = [UIColor clearColor];
    [btnedit setTitle:@"Edit" forState:UIControlStateNormal];
    [btnedit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnedit addTarget:self action:@selector(editCity:) forControlEvents:UIControlEventTouchUpInside];
    
    btnedit.tag = indexPath.row;
    [cell.cellBtnEditBkgView addSubview:btnedit];
    
    return cell;
}


- (IBAction)SaveNewCity:(id)sender {
    
    if (_txtAddNewCity.text.length > 0) {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        if ([_previousvc isEqualToString:@"city"]) {
            [fetcher createNewCityWithName:_txtAddNewCity.text];
        }
        else if ([_previousvc isEqualToString:@"agentgroup"]) {
            [fetcher createNewAgentGroupWithName:_txtAddNewCity.text];
        }
        else if ([_previousvc isEqualToString:@"bustype"]) {
            [fetcher createNewBusTypeWithType:_txtAddNewCity.text];
        }
        else if ([_previousvc isEqualToString:@"tickettype"]) {
            [fetcher createNewTicketType:_txtAddNewCity.text];
        }
        else if ([_previousvc isEqualToString:@"commissiontype"]) {
            [fetcher createnewCommissionType:_txtAddNewCity.text];
        }
    }
}

- (IBAction)CancelSaving:(id)sender {
    _upperView.hidden = YES;
}

- (IBAction)UpdateCity:(id)sender {
    if (_txtNewCityName.text.length > 0) {
        [self JDStatusBarHidden:NO status:@"Updating..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        if ([_previousvc isEqualToString:@"city"]) {
            [fetcher updateCityWithid:_editid withName:_txtNewCityName.text];
        }
        else if ([_previousvc isEqualToString:@"agentgroup"]) {
            [fetcher updateAgentGroupWithid:_editid withName:_txtNewCityName.text];
        }
        else if ([_previousvc isEqualToString:@"bustype"]) {
            [fetcher updateBusTypeWithid:_editid withName:_txtNewCityName.text];
        }
        else if ([_previousvc isEqualToString:@"tickettype"]) {
            [fetcher updateTicketTypeWithid:_editid withName:_txtNewCityName.text];
        }
        else if ([_previousvc isEqualToString:@"commissiontype"]) {
            NSDictionary* dict = @{@"comid": _editid,
                                   @"name": _txtNewCityName.text};
            [fetcher updateCommissiontypeWithDictionary:dict];
        }

    }
    
}
@end
