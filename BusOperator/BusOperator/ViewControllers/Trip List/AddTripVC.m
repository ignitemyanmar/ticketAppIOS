//
//  AddTripVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AddTripVC.h"
#import "RadioButton.h"
#import "SSCheckBoxView.h"
#import "ChooseCityVC.h"
#import "DataFetcher.h"
#import "City.h"
#import "ChooseBusClass.h"
#import "BusClass.h"
#import "JDStatusBarNotification.h"
#import "ChooseSeatPlanVC.h"
#import "Reachability.h"

@interface AddTripVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate>
{
    NSArray *days;
}

@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSMutableArray *checkboxes;
@property (strong, nonatomic) NSString *strBtnTitle;
@property (strong, nonatomic) NSMutableArray* buttons;
@property (strong, nonatomic) NSArray* popoverdata;
@property (strong, nonatomic) NSArray* popoverbusclass;
@property (strong, nonatomic) NSDictionary* tripinfo;
@property (strong, nonatomic) NSString* selectedBusClassid;
@property (strong, nonatomic) NSArray* seatStatus;
@property (assign, nonatomic) int numCol;
@property (assign, nonatomic) int numRow;
@property (strong, nonatomic) NSArray* busSeatPlanArr;
@property (strong, nonatomic) NSMutableDictionary* mySeatStatus;
@property (strong, nonatomic) NSArray* downloadedSeatPlanList;
@property (assign, nonatomic) int selectedSeatPlanid;
@property (strong, nonatomic) UIDatePicker* datePicker;
@property (strong, nonatomic) UIPopoverController* mypopoverController;
@property (strong, nonatomic) NSString* selectedTime;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UIButton *btnFromCity;
@property (strong, nonatomic) IBOutlet UIButton *btnToCity;
@property (strong, nonatomic) IBOutlet UITextField *txtBusTime;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSeatPlan;

@property (strong, nonatomic) IBOutlet UIButton *btnSelectClass;
@property (strong, nonatomic) IBOutlet UITextField *lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnBusClass;
@property (strong, nonatomic) IBOutlet UICollectionView *collviewSeatPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedule;
@property (weak, nonatomic) IBOutlet UILabel *lblBusTime;
@property (weak, nonatomic) IBOutlet UILabel *lblbusclass;
@property (weak, nonatomic) IBOutlet UILabel *lblTitlePrice;



- (IBAction)onSelectFromCityClick:(id)sender;
- (IBAction)onSelectToCityClick:(id)sender;
- (IBAction)onSelectBusClass:(id)sender;
- (IBAction)onSelectBusSeatPlanClick:(id)sender;
- (IBAction)onSelectTimeClick:(id)sender;


@end

@implementation AddTripVC

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
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    _checkboxes = [NSMutableArray new];
    days = @[@"Mon",@"Tue",@"Wed",@"Thurs",@"Fri"];
    _buttons = [NSMutableArray arrayWithCapacity:2];
    
    _numCol = 0;
    _numRow = 0;
    
    [self setupMMFont];
    
    if ([_previousvc isEqualToString:@"editTrip"]) {
        if (self.reachable) {
            //Auto fill trip's data
            [_btnFromCity setTitle:_preFilledData[@"fromCity"] forState:UIControlStateNormal];
            [_btnToCity setTitle:_preFilledData[@"toCity"] forState:UIControlStateNormal];
            _tripinfo = _preFilledData[@"tripDetail"];
            /*
             "seat_plan_id": "1",
             "name": "Elite-27",
             "seat_layout": { }
             */
            [_btnSelectClass setTitle:_tripinfo[@"classes"] forState:UIControlStateNormal];
            _selectedBusClassid = [NSString stringWithFormat:@"%@",_tripinfo[@"class_id"]];//
            //        _txtBusTime.text = _tripinfo[@"time"];
            [_btnSelectTime setTitle:_tripinfo[@"time"] forState:UIControlStateNormal];
            _selectedTime = _tripinfo[@"time"];
            _lblPrice.text = [NSString stringWithFormat:@"%@",_tripinfo[@"price"]];//
            
            [_btnSelectSeatPlan setTitle:_tripinfo[@"name"] forState:UIControlStateNormal];
            _selectedSeatPlanid = [_tripinfo[@"seat_plan_id"] intValue];
            
            //Change Sate plan data structure
            NSDictionary* layoutDict = _tripinfo[@"seat_layout"];
            //        NSArray* seatArr = layoutDict[@"seat_lists"];
            int totalCol = [layoutDict[@"column"] intValue];
            int totalRow = [layoutDict[@"row"] intValue];
            NSArray* tempSeatStatusArr = layoutDict[@"seat_lists"];
            
            int totalCount = 0;
            
            NSMutableArray* mySeat = [NSMutableArray new];
            NSMutableArray* rowSeat = [NSMutableArray new];
            for (int i = 0; i < totalRow; i++) {
                
                NSMutableArray* status = [NSMutableArray new];
                for (int j = 0; j < totalCol; j++) {
                    NSDictionary* dictStatus = tempSeatStatusArr[totalCount];
                    NSString* strStatus = dictStatus[@"status"];
                    [status addObject:strStatus];
                    
                    totalCount++;
                }
                [mySeat addObject:status];
                
            }
            _seatStatus = [mySeat copy];
            _numCol = totalCol;
            _numRow = totalRow;
        }
        else {
            [_btnFromCity setTitle:@"Yangon" forState:UIControlStateNormal];
            [_btnToCity setTitle:@"Bago" forState:UIControlStateNormal];
            [_btnSelectClass setTitle:@"VIP" forState:UIControlStateNormal];
            [_btnSelectTime setTitle:@"09:30 AM" forState:UIControlStateNormal];
            _lblPrice.text = @"8000";
            [_btnSelectSeatPlan setTitle:@"Operator-60" forState:UIControlStateNormal];
            _seatStatus = @[@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"]];
            _numCol = 5;
            _numRow = 12;
        }
        
    }
    //Radio
    [self setRadioBtn];
    
    //Checkbox
    [self setChBxBtns];
    
    //Save Btn
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
//[button setBackgroundColor:[UIColor colorWithRed:116.0f/255 green:206.0f/255 blue:113.0f/255 alpha:1]];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 100, 40);
    [button addTarget:self action:@selector(SaveTripSchedule) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCity:) name:@"didSelectCityFromAddTrip" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBusClass:) name:@"didSelectBusClass" object:nil];
    
    //After downloding
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishCityDownload:) name:@"didFinishCityDownload" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateTrip:) name:@"finishCreateTrip" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishClassDownload:) name:@"finishClassDownload" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUpdateTrip:) name:@"finishUpdateTrip" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetSeatPlanForTripSchedule:) name:@"finishGetSeatPlanForTripSchedule" object:nil];
    
    if (self.reachable) {
        DataFetcher* datafetch = [DataFetcher new];
        [datafetch getAllCities];
        [datafetch getAllBusClasses];
        [datafetch getSeatPlanForTripScheduleWithOpid:1];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBusSeatPlan:) name:@"didSelectBusSeatPlan" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"ChooseCityFromAddTrip" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupMMFont
{
    _btnSelectTime.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTime setTitle:@"ထြက္ခြာခ်ိန္ေရြးပါ" forState:UIControlStateNormal];
    
    _btnBusClass.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnBusClass setTitle:@"Busအမ်ိဴးအစားေရြးပါ" forState:UIControlStateNormal];
    
    _btnFromCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnFromCity setTitle:@"ခရီးစဥ္အစ ေရြးပါ" forState:UIControlStateNormal];
    
    _btnToCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnToCity setTitle:@"ခရီးစဥ္အဆံုုး ေရြးပါ" forState:UIControlStateNormal];
    
    _btnSelectSeatPlan.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectSeatPlan setTitle:@"Busထိုုင္ခံုုအစီအစဥ္ ေရြးပါ" forState:UIControlStateNormal];
    
    _lblSchedule.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSchedule.text = @"ရက္ေရြးပါ :";
    
    _lblBusTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusTime.text = @"ထြက္ခြာခ်ိန္ :";
    
    _lblTitlePrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitlePrice.text = @"ေစ်းႏႈန္း :";
    
    _lblbusclass.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblbusclass.text = @"Busအမ်ိဴးအစား :";
}

- (void)setRadioBtn
{
    
    
	CGRect btnRect = CGRectMake(175, 245, 100, 30);
	for (NSString* optionTitle in @[@"Daily", @"Other"]) {
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
		[self.view addSubview:btn];
		[_buttons addObject:btn];
	}
    
	[_buttons[0] setGroupButtons:_buttons]; // Setting buttons into the group
    
    if ([_previousvc isEqualToString:@"editTrip"]) {
        if ([_tripinfo[@"available_day"] isEqualToString:@"Daily"]) {
            [_buttons[0] setSelected:YES];
        }
        else {
            [_buttons[1] setSelected:YES];
        }
    }
    else [_buttons[1] setSelected:YES];
}

- (void)setChBxBtns
{
    SSCheckBoxView *cbv = nil;
    CGRect frame = CGRectMake(55, 285, 240, 30);
    for (int i = 0; i < 5; ++i) {
        SSCheckBoxViewStyle style = (4 % kSSCheckBoxViewStylesCount);
        BOOL checked = (i < 5);
        cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                              style:style
                                            checked:NO];
        [cbv setText:[NSString stringWithFormat:@"%@", days[i]]];
        [cbv setStateChangedTarget:self
                          selector:@selector(checkBoxViewChangedState:)];
        
        [self.view addSubview:cbv];
        [self.checkboxes addObject:cbv];
        
        frame.origin.x += 100;
    }
    frame.origin.x = 180;
    frame.origin.y = 325;
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:(4 % kSSCheckBoxViewStylesCount)
                                        checked:NO];
    [cbv setText:@"Sat"];
    [cbv setStateChangedTarget:self
                      selector:@selector(checkBoxViewChangedState:)];
    
    [self.view addSubview:cbv];
    [self.checkboxes addObject:cbv];
    
    frame.origin.x += 100;
    
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:(4 % kSSCheckBoxViewStylesCount)
                                        checked:NO];
    [cbv setText:@"Sun"];
    [cbv setStateChangedTarget:self
                      selector:@selector(checkBoxViewChangedState:)];
    
    [self.view addSubview:cbv];
    [self.checkboxes addObject:cbv];
    
    if ([_previousvc isEqualToString:@"editTrip"]) {
        if ([_tripinfo[@"available_day"] isEqualToString:@"Daily"]) {
            
            for (SSCheckBoxView *cbv in self.checkboxes) {
                cbv.enabled = !cbv.enabled;
            }
        }
        else {
            NSString* strDays = _tripinfo[@"available_day"];
            NSArray* arrDays = [strDays componentsSeparatedByString:@"-"];
            NSArray* arrChBox = [self.checkboxes copy];
            for (NSString* str in arrDays) {
                for (int i =0; i < arrChBox.count; i++) {
                    SSCheckBoxView* cbv = arrChBox[i];
                    NSString* chboxTitle = cbv.getChboxLabel;
                    if ([chboxTitle isEqualToString:str]) {
                        SSCheckBoxView* chbox = self.checkboxes[i];
                        [chbox setChecked:YES];
                    }
                }

            }
        }
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


- (void)SaveTripSchedule
{
    if (!self.reachable) {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        return;
    }
    if (![_btnFromCity.titleLabel.text isEqualToString:@"ခရီးစဥ္အစ ေရြးပါ"] && ![_btnToCity.titleLabel.text isEqualToString:@"ခရီးစဥ္အဆံုုး ေရြးပါ"] && ![_btnBusClass.titleLabel.text isEqualToString:@"Busအမ်ိဴးအစားေရြးပါ"] && (_lblPrice.text.length > 0) && (_selectedTime.length > 0)) {
        
        NSString* fromid;
        NSString* toid;
        NSString* strClass = @"";
        NSMutableString* strDay = [NSMutableString new];
        NSString* strTime = @"";
        NSString* strPrice = @"";
        
        if (![_btnFromCity.titleLabel.text isEqualToString:@"ခရီးစဥ္အစ ေရြးပါ"] && ![_btnToCity.titleLabel.text isEqualToString:@"ခရီးစဥ္အဆံုုး ေရြးပါ"]) {
            for (City* city in _popoverdata) {
                if ([city.name isEqualToString:_btnFromCity.titleLabel.text]) {
                    fromid = city.id;
                }
                if ([city.name isEqualToString:_btnToCity.titleLabel.text]) {
                    toid = city.id;
                }
            }
        }
        
        if (![_btnSelectClass.titleLabel.text isEqualToString:@"Busအမ်ိဴးအစားေရြးပါ"]) {
            strClass = _btnSelectClass.titleLabel.text;
        }
        NSMutableArray* muArr = [NSMutableArray new];
        RadioButton* rdbtn = _buttons[0];
        if (rdbtn.selected) {
            [strDay appendString:@"Daily"];
        }
        else {
            for (int i =0; i < _checkboxes.count; i++) {
                SSCheckBoxView* cbv = _checkboxes[i];
                if (cbv.checked) {
                    [muArr addObject:cbv.getChboxLabel];
                    
                }
            }
            if (muArr.count > 0) {
                for (int i = 0; i < muArr.count; i++) {
                    if (i == muArr.count-1) {
                        [strDay appendString:muArr[i]];
                    }
                    else {
                        [strDay appendFormat:@"%@-",muArr[i]];
                    }
                }
            }
        }
        
        if (_txtBusTime.text.length > 0) {
            strTime = _txtBusTime.text;
        }
        
        if (_lblPrice.text.length > 0) {
            strPrice = _lblPrice.text;
        }
        
        NSLog(@"strday : %@",strDay);
        //        NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        if (strDay.length > 0)
        {
            DataFetcher* dataFetch = [DataFetcher new];
            [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
            if ([_previousvc isEqualToString:@"editTrip"]) {
                
                int tripid = [_tripinfo[@"id"] intValue];
                NSDictionary* dictToPass = @{@"opid": @(1), @"fromCity": fromid, @"toCity": toid, @"classid": _selectedBusClassid, @"scheduledate": strDay, @"price": strPrice, @"time": _selectedTime, @"tripid": @(tripid), @"seatplanid": @(_selectedSeatPlanid)};
                [dataFetch updateTripWithOpid:dictToPass];
            }
            else {
                NSDictionary* dictToPass = @{@"opid": @(1), @"fromCity": fromid, @"toCity": toid, @"classid": _selectedBusClassid, @"scheduledate": strDay, @"price": strPrice, @"time": _selectedTime, @"seatplanid": @(_selectedSeatPlanid)};
                [dataFetch createTrip:dictToPass];
            }
            
        }
        else {
            [self JDStatusBarHidden:NO status:@"All fields are required to save this trip schedule!" duration:3];
        }
    }
    else {
        [self JDStatusBarHidden:NO status:@"All fields are required to save this trip schedule!" duration:3];
    }
    
}

- (void)checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    
}

- (void)didSelectBusClass:(NSNotification*)notification
{
    if (self.reachable) {
        BusClass* busclass = (BusClass*)notification.object;
        _selectedBusClassid = busclass.id;
        [_btnSelectClass setTitle:busclass.name forState:UIControlStateNormal];
    }
    else {
        NSString* str = (NSString*)notification.object;
        [_btnSelectClass setTitle:str forState:UIControlStateNormal];
    }
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectCity:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    if ([_strBtnTitle isEqualToString:@"FromCity"]) {
        
        [_btnFromCity setTitle:str forState:UIControlStateNormal];
    }
    else [_btnToCity setTitle:str forState:UIControlStateNormal];
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectBusSeatPlan:(NSNotification*)noti
{
    if (self.reachable) {
        NSDictionary* dict = (NSDictionary*)noti.object;
        
        NSString* str = dict[@"name"];
        [_btnSelectSeatPlan setTitle:str forState:UIControlStateNormal];
        [_myPopoverController dismissPopoverAnimated:YES];
        
        NSString* strid = dict[@"id"];
        _selectedSeatPlanid = [strid intValue];
        NSArray* tempArr = _mySeatStatus[strid];
        _seatStatus = [tempArr copy];
        
        for (NSDictionary* layoutDict in _downloadedSeatPlanList) {
            NSString* idStr = layoutDict[@"id"];
            if ([idStr isKindOfClass:[NSString class]]) {
                if ([idStr isEqualToString:strid]) {
                    NSDictionary* seatDict = layoutDict[@"seat_layout"];
                    _numCol = [seatDict[@"column"] intValue];
                    _numRow = [seatDict[@"row"] intValue];
                }
            }
            else {
                if (idStr == strid) {
                    NSDictionary* seatDict = layoutDict[@"seat_layout"];
                    _numCol = [seatDict[@"column"] intValue];
                    _numRow = [seatDict[@"row"] intValue];
                }
            }
            
            
        }

    }
    else {
        NSString* str = (NSString*)noti.object;
        [_btnSelectSeatPlan setTitle:str forState:UIControlStateNormal];
        [_myPopoverController dismissPopoverAnimated:YES];
        
        _seatStatus = @[@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"]];
        _numCol = 5;
        _numRow = 12;
        
    }
    
    [_collviewSeatPlan reloadData];
}


#pragma mark - After downloading
- (void)didFinishCityDownload:(NSNotification *)noti
{
    NSArray* temp = (NSArray *)noti.object;
    _popoverdata = [temp copy];
}

- (void)finishClassDownload:(NSNotification*)noti
{
    NSArray* temp = (NSArray *)noti.object;
    _popoverbusclass = [temp copy];
}

- (void)finishCreateTrip:(NSNotification *)noti
{
    
    NSString* status = (NSString *)noti.object;
    if ([status isEqualToString:@"success"]) {
        
        [_btnFromCity setTitle:@"Select City" forState:UIControlStateNormal];
        [_btnToCity setTitle:@"Select City" forState:UIControlStateNormal];
        [_btnSelectClass setTitle:@"Select Bus Class" forState:UIControlStateNormal];
        _txtBusTime.text = @"";
        _lblPrice.text = @"";
        [_btnSelectSeatPlan setTitle:@"Select Bus Seat Plan" forState:UIControlStateNormal];
        _numCol = 0;
        _numRow = 0;
        [_collviewSeatPlan reloadData];
        [_buttons[1] setSelected:YES];
        for (SSCheckBoxView *cbv in self.checkboxes) {
            cbv.checked = NO;
        }

//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Successfully created trip." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
        
    }
    
    [self JDStatusBarHidden:NO status:status duration:3];
}

- (void)finishUpdateTrip:(NSNotification*)noti
{
    
    NSString* status = (NSString *)noti.object;
//    if ([status isEqualToString:@"success"]) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Successfully updated trip." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//    }
    [self JDStatusBarHidden:NO status:status duration:3];
}

- (void)finishGetSeatPlanForTripSchedule:(NSNotification*)noti
{
    NSArray* resultArr = (NSArray*)noti.object;
    _downloadedSeatPlanList = [resultArr copy];
    NSMutableArray* muarr = [NSMutableArray new];
    NSMutableArray* muSeatLayoutList = [NSMutableArray new];
    for (NSDictionary* dict in resultArr) {
        NSDictionary* tempdict = @{@"id": dict[@"id"], @"name": dict[@"name"]};
        [muarr addObject:tempdict];
        
        NSDictionary* layoutDict = dict[@"seat_layout"];
        [muSeatLayoutList addObject:layoutDict];
    }
    _busSeatPlanArr = [muarr copy];
    
    
    
    _mySeatStatus = [NSMutableDictionary new];
    
    NSMutableArray* mySeat;
    NSMutableArray* rowSeat;
    for (int outerCount=0; outerCount < muSeatLayoutList.count; outerCount++) {
        NSDictionary* dict = muSeatLayoutList[outerCount];
        int totalCol = [dict[@"column"] intValue];
        int totalRow = [dict[@"row"] intValue];
        NSArray* tempSeatStatusArr = dict[@"seat_lists"];
        
        int totalCount = 0;
        
        mySeat = [NSMutableArray new];
        rowSeat = [NSMutableArray new];
        for (int i = 0; i < totalRow; i++) {
            
            NSMutableArray* status = [NSMutableArray new];
            for (int j = 0; j < totalCol; j++) {
                NSDictionary* dictStatus = tempSeatStatusArr[totalCount];
                NSString* strStatus = dictStatus[@"status"];
                [status addObject:strStatus];
                
                totalCount++;
            }
            [mySeat addObject:status];
            
        }
        NSDictionary* nameDict = resultArr[outerCount];
        NSString* idStr = nameDict[@"id"];
        [_mySeatStatus setObject:mySeat forKey:idStr];
        
    }
    
    NSLog(@"mySeatStatus Arr is %@", _mySeatStatus);
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
//    ChooseCityVC* destvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
//    destvc.tripList = _cities;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRadioClick:(id)sender {

    RadioButton *btnRadio = (RadioButton *)sender;
    NSString *str = btnRadio.titleLabel.text;
    
    for (SSCheckBoxView *cbv in self.checkboxes) {
        cbv.enabled = !cbv.enabled;
    }

}
- (IBAction)onSelectFromCityClick:(id)sender {
    _strBtnTitle = @"FromCity";
    
    ChooseCityVC* cityvc = (ChooseCityVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCityVC"];
    _myPopoverController = [[UIPopoverController alloc] initWithContentViewController:cityvc];
    if (self.reachable) {
        cityvc.tripList = [_popoverdata copy];
    }
    [_myPopoverController presentPopoverFromRect:_btnFromCity.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)onSelectToCityClick:(id)sender {
    _strBtnTitle = @"ToCity";
    
    ChooseCityVC* cityvc = (ChooseCityVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCityVC"];
    _myPopoverController = [[UIPopoverController alloc] initWithContentViewController:cityvc];
    if (self.reachable) {
        cityvc.tripList = [_popoverdata copy];
    }
    [_myPopoverController presentPopoverFromRect:_btnToCity.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)onSelectBusClass:(id)sender {
    ChooseBusClass* cityvc = (ChooseBusClass *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseBusClass"];
    _myPopoverController = [[UIPopoverController alloc] initWithContentViewController:cityvc];
    if (self.reachable) {
        cityvc.tripList = [_popoverbusclass copy];
    }
    
    [_myPopoverController presentPopoverFromRect:_btnBusClass.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)onSelectBusSeatPlanClick:(id)sender {
    
    ChooseSeatPlanVC* cityvc = (ChooseSeatPlanVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseSeatPlanVC"];
    _myPopoverController = [[UIPopoverController alloc] initWithContentViewController:cityvc];
    if (self.reachable) {
        cityvc.tripList = [_busSeatPlanArr copy];
    }
    
    [_myPopoverController presentPopoverFromRect:_btnSelectSeatPlan.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)onSelectTimeClick:(id)sender {
    
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor whiteColor];
    
    _datePicker=[[UIDatePicker alloc]init];//Date picker
    _datePicker.frame=CGRectMake(0,0,320, 216);
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_datePicker setMinuteInterval:15];
    [_datePicker setTag:10];
    [popoverView addSubview:_datePicker];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(35, 210, 250, 40);
    [button addTarget:self action:@selector(didSelectShowTimeFromTimePicker) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    [popoverView addSubview:button];
    
    popoverContent.view = popoverView;
    _mypopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    _mypopoverController.delegate = self;
    
    [_mypopoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [_mypopoverController presentPopoverFromRect:_btnSelectTime.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)didSelectShowTimeFromTimePicker
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm a"];
    _selectedTime = [outputFormatter stringFromDate:_datePicker.date];
    [_btnSelectTime setTitle:_selectedTime forState:UIControlStateNormal];
    [_mypopoverController dismissPopoverAnimated:YES];
}

#pragma mark - UICollectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _numCol;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    
    return _numRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"collCellSeatPlan";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    NSArray* tempArr = _seatStatus[indexPath.section];
    NSString* str = [NSString stringWithFormat:@"%@",tempArr[indexPath.item]];
    
    if ([str isEqualToString:@"1"]) {
        cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
    }
    else if ([str isEqualToString:@"0"])
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.layer.borderWidth = 0;
        
    }
    else if ([str isEqualToString:@"2"])
    {
        cell.backgroundColor = [UIColor redColor];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
        
    }
    
    //    if (self.currentSeatNum < _seatStatus.count-1) {
    //        self.currentSeatNum++;
    //    } else self.currentSeatNum = 0;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = _collviewSeatPlan.frame.size.width/_numCol;
    CGFloat cellHeight = _collviewSeatPlan.frame.size.height/_numRow;
    return CGSizeMake(cellWidth, cellHeight);
}


@end
