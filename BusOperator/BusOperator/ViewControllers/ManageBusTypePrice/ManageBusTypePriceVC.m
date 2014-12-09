//
//  ManageBusTypePriceVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/27/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ManageBusTypePriceVC.h"

@interface ManageBusTypePriceVC ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIButton *btnFromCity;
@property (strong, nonatomic) IBOutlet UIButton *btnToCity;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) NSString *popovername;

@property (assign, nonatomic) CGRect textFieldFrame;
@property (strong, nonatomic) NSMutableArray *busTypes;
@property (strong, nonatomic) NSMutableArray *busPrices;
@property (assign, nonatomic) CGRect nexTxtFrame;

- (IBAction)SelectFromCity:(id)sender;
- (IBAction)SelectToCity:(id)sender;
- (IBAction)AddMoreTxtField:(id)sender;


@end

@implementation ManageBusTypePriceVC

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
    
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(saveBusPrice) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    _busTypes = [NSMutableArray new];
    
    _textFieldFrame = CGRectMake(300.0, 200.0, 200.0, 50.0);
    UITextField *textField = [[UITextField alloc] initWithFrame:_textFieldFrame];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont fontWithName:@"Zawgyi-One" size:14.0f]];
//    _lblTitleDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
//    _lblTitleDate.text = @"ေန ့ရက္";
    [textField setPlaceholder:@"Busအမ်ိဴးစား ျဖည္ ့ပါ"];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.keyboardType = UIKeyboardTypeDefault;
    [_busTypes addObject:textField];
    [_scrollview addSubview:textField];
    
    _busPrices = [NSMutableArray new];
    
    _nexTxtFrame = CGRectMake(585, 200, 200, 50);
    UITextField *nexTxtField = [[UITextField alloc] initWithFrame:_nexTxtFrame];
    [nexTxtField setBorderStyle:UITextBorderStyleBezel];
    [nexTxtField setTextColor:[UIColor blackColor]];
    [nexTxtField setFont:[UIFont fontWithName:@"Zawgyi-One" size:14.0f]];
    [nexTxtField setPlaceholder:@"လတ္မွတ္ခ ျဖည္ ့ပါ"];
    [nexTxtField setTextAlignment:NSTextAlignmentCenter];
    [nexTxtField setBackgroundColor:[UIColor whiteColor]];
    nexTxtField.keyboardType = UIKeyboardTypeDefault;
    [_busPrices addObject:nexTxtField];
    [_scrollview addSubview:nexTxtField];
    
    _btnFromCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    _btnToCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    
    [_btnFromCity setTitle:@"အစ ျမို ုု ့ေရြးပါ" forState:UIControlStateNormal];
    [_btnToCity setTitle:@"အဆံုုး ျမိ ုု ့ေရြးပါ" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityFromBusPrice:) name:@"didSelectCityFromBusPrice" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"ManageBusPrice" forKey:@"currentvc"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (void)didSelectCityFromBusPrice:(NSNotification *)notification
{
    NSString* str = (NSString*)notification.object;
    if ([_popovername isEqualToString:@"FromCity"]) {
        [_btnFromCity setTitle:str forState:UIControlStateNormal];
    }
    else if ([_popovername isEqualToString:@"ToCity"]) {
        [_btnToCity setTitle:str forState:UIControlStateNormal];
    }
    [_myPopoverController dismissPopoverAnimated:YES];

}

- (IBAction)SelectFromCity:(id)sender {
    _popovername = @"FromCity";
}

- (IBAction)SelectToCity:(id)sender {
    _popovername = @"ToCity";
}

- (IBAction)AddMoreTxtField:(id)sender {
    //txtField Add
    _textFieldFrame.origin.y += 80;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:_textFieldFrame];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont fontWithName:@"Zawgyi-One" size:14.0f]];
    [textField setPlaceholder:@"Busအမ်ိဴးစား ျဖည္ ့ပါ"];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setTextAlignment:NSTextAlignmentCenter];
    textField.keyboardType = UIKeyboardTypeDefault;
    [_busTypes addObject:textField];
    [_scrollview addSubview:textField];
    
    _nexTxtFrame.origin.y += 80;
    UITextField *nexTxtField = [[UITextField alloc] initWithFrame:_nexTxtFrame];
    [nexTxtField setBorderStyle:UITextBorderStyleBezel];
    [nexTxtField setTextColor:[UIColor blackColor]];
    [nexTxtField setFont:[UIFont fontWithName:@"Zawgyi-One" size:14.0f]];
    [nexTxtField setPlaceholder:@"လတ္မွတ္ခ ျဖည္ ့ပါ"];
    [nexTxtField setBackgroundColor:[UIColor whiteColor]];
    [nexTxtField setTextAlignment:NSTextAlignmentCenter];
    nexTxtField.keyboardType = UIKeyboardTypeDefault;
    [_busPrices addObject:nexTxtField];
    [_scrollview addSubview:nexTxtField];

    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _nexTxtFrame.origin.y+400);
}

- (void)saveBusPrice
{
    for (int i=0; i < _busTypes.count; i++) {
        UITextField* txtfield = _busTypes[i];
        NSLog(@"Bus Type %d : %@",i,txtfield.text);
        txtfield = _busPrices[i];
        NSLog(@"Bus Price %d : %@",i,txtfield.text);
    }
    
    NSArray* tempArr = _busPrices;
    for (int i = tempArr.count-1; i > 0; i--) {
        UITextField* txtfield = tempArr[i];
        [txtfield removeFromSuperview];
        [_busPrices removeObjectAtIndex:i];
        
        UITextField* txtfieldtype = _busTypes[i];
        [txtfieldtype removeFromSuperview];
        [_busTypes removeObjectAtIndex:i];
    }
    
    UITextField* txtfield = _busTypes[0];
    txtfield.text = @"";
    
    UITextField* txtfieldPrice = _busPrices[0];
    txtfieldPrice.text = @"";
    
    [_btnFromCity setTitle:@"အစ ျမို ုု ့ေရြးပါ" forState:UIControlStateNormal];
    [_btnToCity setTitle:@"အဆံုုး ျမိ ုု ့ေရြးပါ" forState:UIControlStateNormal];
    
    _nexTxtFrame = CGRectMake(585, 200, 200, 50);
    _textFieldFrame = CGRectMake(300.0, 200.0, 200.0, 50.0);
}
@end
