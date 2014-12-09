//
//  AddNewBusScheduleVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/28/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AddNewBusScheduleVC.h"
#import "ChooseBusClass.h"

@interface AddNewBusScheduleVC () <UITextFieldDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) CGRect textFieldFrame;
@property (assign, nonatomic) CGRect frameBtn;
@property (strong, nonatomic) NSMutableArray *myBtnArr;
@property (strong, nonatomic) NSMutableArray *myTxtfieldArr;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSString *popovername;
@property (strong, nonatomic) UIButton* selectedBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIButton *btnFromCity;
@property (strong, nonatomic) IBOutlet UIButton *btnToCity;
@property (strong, nonatomic) IBOutlet UIButton *btnFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnToDate;

- (IBAction)AddMoreBus:(id)sender;
- (IBAction)onFromCityClick:(id)sender;
- (IBAction)onToCityClick:(id)sender;
- (IBAction)onFromDateClick:(id)sender;
- (IBAction)onToDateClick:(id)sender;

@end

@implementation AddNewBusScheduleVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBusClass:) name:@"didSelectBusClass" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityFromAddNewBusSchedule:) name:@"didSelectCityFromAddNewBusSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDateFromAddNewBusSchedule:) name:@"didSelectDateFromAddNewBusSchedule" object:nil];
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    _myBtnArr = [NSMutableArray new];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(saveBusShedule) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    _myTxtfieldArr = [NSMutableArray new];
    
    _textFieldFrame = CGRectMake(133.0, 228.0, 200.0, 50.0);
    UITextField *textField = [[UITextField alloc] initWithFrame:_textFieldFrame];
    [textField setBorderStyle:UITextBorderStyleBezel];
    
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont systemFontOfSize:20]];
    [textField setDelegate:self];
    [textField setPlaceholder:@"Enter Bus Number"];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.keyboardType = UIKeyboardTypeDefault;
    [_myTxtfieldArr addObject:textField];
    [_scrollview addSubview:textField];
    
    UIButton *btnClass = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnClass setTitle:@"Select Bus Type" forState:UIControlStateNormal];
    [btnClass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClass setBackgroundColor:[UIColor blackColor]];
    _frameBtn = CGRectMake(417,228, 200, 50);
    btnClass.frame = _frameBtn;
    [btnClass addTarget:self action:@selector(showBusClassPopover:) forControlEvents:UIControlEventTouchUpInside];
    btnClass.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    [_myBtnArr addObject:btnClass];
    [_scrollview addSubview:btnClass];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _scrollview.delegate = self;
    [[NSUserDefaults standardUserDefaults] setObject:@"addnewBusSchedule" forKey:@"currentvc"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}


- (void)didSelectBusClass:(NSNotification *)notification
{
    NSString* str = (NSString *)notification.object;
    [_selectedBtn setTitle:str forState:UIControlStateNormal];
    [_popover dismissPopoverAnimated:YES];
}

- (void)didSelectCityFromAddNewBusSchedule:(NSNotification *)notification
{
    NSString* str = (NSString*)notification.object;
    if ([_popovername isEqualToString:@"FromCity"]) {
        [_btnFromCity setTitle:str forState:UIControlStateNormal];
    }
    else if ([_popovername isEqualToString:@"ToCity"]){
        [_btnToCity setTitle:str forState:UIControlStateNormal];
    }
    
    [_myPopoverController dismissPopoverAnimated:YES];

}

- (void)didSelectDateFromAddNewBusSchedule:(NSNotification *)notification
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

- (void)showBusClassPopover:(id)sender
{
    UIButton* myBtn = (UIButton*)sender;
    _selectedBtn = myBtn;
    ChooseBusClass *viewController = (ChooseBusClass*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseBusClass"];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
//    popover.delegate = self;
//    popover.popoverContentSize = CGSizeMake(644, 425); //your custom size.
    [_popover presentPopoverFromRect:myBtn.frame inView:self.scrollview permittedArrowDirections: UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)AddMoreBus:(id)sender {
    
    _textFieldFrame.origin.y += 80;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:_textFieldFrame];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont systemFontOfSize:20]];
    [textField setDelegate:self];
    [textField setPlaceholder:@"Enter Bus Number"];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.keyboardType = UIKeyboardTypeDefault;
    [_myTxtfieldArr addObject:textField];
    [_scrollview addSubview:textField];
    
    //Btn Add
    _frameBtn.origin.y += 80;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Select Bus Class" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    button.frame = _frameBtn;
    [button addTarget:self action:@selector(showBusClassPopover:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    [_myBtnArr addObject:button];
    [_scrollview addSubview:button];
    
    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _frameBtn.origin.y+400);
}

- (IBAction)onFromCityClick:(id)sender {
    _popovername = @"FromCity";
}

- (IBAction)onToCityClick:(id)sender {
    _popovername = @"ToCity";
}

- (IBAction)onFromDateClick:(id)sender {
    _popovername = @"FromDate";
}

- (IBAction)onToDateClick:(id)sender {
    _popovername = @"ToDate";
}

- (void)saveBusShedule
{
    for (int i=0; i < _myTxtfieldArr.count; i++) {
        UITextField* txtfield = _myTxtfieldArr[i];
        NSLog(@"Bus Type %d : %@",i,txtfield.text);
        UIButton* btn = _myBtnArr[i];
        NSLog(@"Bus Price %d : %@",i,btn.titleLabel.text);
    }
    
    NSArray* tempArr = _myBtnArr;
    for (int i = tempArr.count-1; i > 0; i--) {
        UIButton* btn = tempArr[i];
        [btn removeFromSuperview];
        [_myBtnArr removeObjectAtIndex:i];
        
        UITextField* txtfieldtype = _myTxtfieldArr[i];
        [txtfieldtype removeFromSuperview];
        [_myTxtfieldArr removeObjectAtIndex:i];
    }
    
    UITextField* txtfield = _myTxtfieldArr[0];
    txtfield.text = @"";
    
    UIButton* btnBusclass = _myBtnArr[0];
    [btnBusclass setTitle:@"Select Bus Type" forState:UIControlStateNormal];

    
    
}

@end
