//
//  OperatorShowEditAllVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/30/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "OperatorShowEditAllVC.h"
#import "JDStatusBarNotification.h"
#import "TripReportCell.h"
#import "DataFetcher.h"
#import "Operator.h"

@interface OperatorShowEditAllVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* dataFiller;
@property (assign, nonatomic) BOOL isEditMode;
@property (strong, nonatomic) NSString* editedopid;

@property (weak, nonatomic) IBOutlet UILabel *lblOperatorName;
@property (weak, nonatomic) IBOutlet UILabel *lblPh;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (weak, nonatomic) IBOutlet UITableView *tbOperator;
@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UILabel *lblAddNewTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPh;
@property (weak, nonatomic) IBOutlet UIView *viewAddNew;
@property (weak, nonatomic) IBOutlet UITextField *txtemail;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;

//Edit Control
@property (weak, nonatomic) IBOutlet UIView *viewEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblEditEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEditPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEditName;
@property (weak, nonatomic) IBOutlet UITextField *txtEditAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtEditPh;
@property (weak, nonatomic) IBOutlet UITextField *txtEditNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblEditIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblEditTitle;


- (IBAction)SaveNewOperator:(id)sender;
- (IBAction)CancelAddNew:(id)sender;
- (IBAction)SaveEdit:(id)sender;
- (IBAction)CancelEdit:(id)sender;

@end

@implementation OperatorShowEditAllVC

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
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(addNewOperator) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetOperatorList:) name:@"finishGetOperatorList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateOperator:) name:@"finishCreateOperator" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateOperator:) name:@"finishUpdateOperator" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDeleteOperator:) name:@"finishDeleteOperator" object:nil];
    
    _viewUpper.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"operatorshowalleditvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllOperatorsList];
    
    [self setupMMFont];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _viewUpper.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    _viewAddNew.layer.cornerRadius = 5.0f;
    _viewAddNew.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewAddNew.layer.borderWidth = 3.0f;
    
    _viewEdit.layer.cornerRadius = 5.0f;
    _viewEdit.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewEdit.layer.borderWidth = 3.0f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMMFont
{
    _txtName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtpassword.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtemail.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtAddress.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtPh.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblEditEmail.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtEditName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtEditPassword.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtEditAddress.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtEditPh.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _txtEditNewPassword.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblAddNewTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    _lblAddNewTitle.text = @"၀န္ေဆာင္မႈလုုပ္ငန္းအသစ္ထည့္ပါ";
    
    _lblEditTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    _lblEditTitle.text = @"၀န္ေဆာင္မႈလုုပ္ငန္းအခ်က္အလက္ ျပင္ဆင္ပါ";
}

- (void)addNewOperator
{
    _viewUpper.hidden = NO;
    _viewAddNew.hidden = NO;
    _viewEdit.hidden = YES;
    _isEditMode = NO;
}

- (void)finishGetOperatorList:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    
    [_tbOperator reloadData];
}

- (void)finishCreateOperator:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    _txtName.text = @"";
    _txtAddress.text = @"";
    _txtPh.text = @"";
    _txtemail.text = @"";
    _txtpassword.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllOperatorsList];
}

- (void)finishUpdateOperator:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    _viewUpper.hidden = YES;
    _txtEditPassword.text = @"";
    _txtEditNewPassword.text = @"";
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllOperatorsList];
}

- (void)finishDeleteOperator:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:3];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getAllOperatorsList];
    
}

- (void)deleteOperator:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    Operator* operator = _dataFiller[btn.tag];
    
    [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher deleteOperatorWithid:operator.id];
}

- (void)editOperator:(id)sender
{
//    _lblAddNewTitle.text = @"Edit Operator";
    UIButton* btnEdit = (UIButton*)sender;
    Operator* operator = _dataFiller[btnEdit.tag];
    
    _editedopid = operator.id;
    
    _viewUpper.hidden = NO;
    _viewAddNew.hidden = YES;
    _viewEdit.hidden = NO;
    
    NSDictionary* logininfo = operator.login_info;
    _lblEditEmail.text = logininfo[@"username"];
    _txtEditName.text = operator.name;
    _txtEditAddress.text = operator.address;
    _txtEditPh.text = operator.phone;

    
    _isEditMode = YES;
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
    NSString* cellid = @"showeditallCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    Operator* opObj = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = opObj.name;
    cell.cellLblTotalSeat.text = opObj.phone;
    cell.cellLblTotalSales.text = opObj.address;
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Delete" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(deleteOperator:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btnedit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnedit.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnedit.backgroundColor = [UIColor clearColor];
    [btnedit setTitle:@"Edit" forState:UIControlStateNormal];
    [btnedit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnedit addTarget:self action:@selector(editOperator:) forControlEvents:UIControlEventTouchUpInside];
    
    btnedit.tag = indexPath.row;
    [cell.cellBtnEditBkgView addSubview:btnedit];
    
    
    return cell;
}


- (IBAction)SaveNewOperator:(id)sender {
    
    if ((_txtName.text.length > 0) && _txtAddress.text.length > 0 && _txtPh.text.length > 0)
    {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
                    [fetcher createNewOperator:_txtName.text withAddress:_txtAddress.text withPh:_txtPh.text withEmail:_txtemail.text withPassword:_txtpassword.text];
    }

}

- (IBAction)CancelAddNew:(id)sender {
    
    _viewUpper.hidden = YES;
}

- (IBAction)SaveEdit:(id)sender {
    
    if ((_txtEditPassword.text.length > 0) && (_txtEditName.text.length > 0) && (_txtEditAddress.text.length > 0) && (_txtEditPh.text.length > 0))
    {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];

        NSDictionary* dict = @{@"opid": _editedopid,
                                   @"name": _txtEditName.text,
                                   @"ph": _txtEditPh.text,
                                   @"address": _txtEditAddress.text,
                                   @"password": _txtEditPassword.text,
                                   @"newpassword": _txtEditNewPassword.text};
        [fetcher updateOperatorWithDictionary:dict];

    }
    
}

- (IBAction)CancelEdit:(id)sender {
    _viewUpper.hidden = YES;
}
@end
