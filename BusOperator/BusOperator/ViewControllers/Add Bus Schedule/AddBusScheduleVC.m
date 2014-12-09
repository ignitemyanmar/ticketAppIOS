//
//  AddBusScheduleVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AddBusScheduleVC.h"
#import "BusCell.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "SelectBusTypeVC.h"
#import "SeatReservationVC.h"

@interface AddBusScheduleVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIPopoverController *mypopoverController;
@property (strong, nonatomic) UIButton* myBtn;
@property (strong, nonatomic) NSString* currentBusNo;
@property (strong, nonatomic) NSString* currentBusType;
@property (assign, nonatomic) NSInteger currentindex;
@property (strong, nonatomic) NSMutableDictionary *muDict;

@property (strong, nonatomic) IBOutlet UIView *bkgBtnView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTime;
@property (strong, nonatomic) IBOutlet UITextField *txtNumOfBus;
@property (strong, nonatomic) IBOutlet UIView *bkgBusView;
@property (strong, nonatomic) IBOutlet UITableView *tvBusList;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnReserveseat;

- (IBAction)addBus:(id)sender;
- (IBAction)reserveSeat:(id)sender;


@end

@implementation AddBusScheduleVC

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
    
    self.title = @"Add Bus Schedule";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBusTypeOnClicked:) name:@"selectBusTypeOnClicked" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(busTypeRetured:) name:@"busTypeRetured" object:nil];
    
    [self addDashedBorder:_bkgBtnView];
    [self addDashedBorder:_bkgBusView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFromBusSchedule:) name:@"selectFromBusSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDateFromBusSchedule:) name:@"selectDateFromBusSchedule" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTimeFromBusSchedule:) name:@"selectTimeFromBusSchedule" object:nil];
    
    _muDict = [[NSMutableDictionary alloc] init];
    
    _btnSelectTrip.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTrip setTitle:@"ခရီးစဥ္" forState:UIControlStateNormal];
    
    _btnSelectTime.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTime setTitle:@"ကားထြက္ခ်ိန္" forState:UIControlStateNormal];
    
    _btnSelectDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectDate setTitle:@"ေန ့ရက္" forState:UIControlStateNormal];
    
    _btnAdd.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnAdd setTitle:@"Busေပါင္းထဲ့ပါ" forState:UIControlStateNormal];
    
    _btnReserveseat.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnReserveseat setTitle:@"ခံုုReserveလုုပ္ရန္" forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"addbusschedulevc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     _mypopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
 }


- (IBAction)addBus:(id)sender {
    
    if (_txtNumOfBus.text.length > 0) {
        [_tvBusList reloadData];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enter number of Bus" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)reserveSeat:(id)sender {
    
//    SeatReservationVC
    if ([_btnSelectTrip.titleLabel.text isEqualToString:@"Select Trip"] || [_btnSelectDate.titleLabel.text isEqualToString:@"Select Date"] || [_btnSelectTime.titleLabel.text isEqualToString:@"Select Time"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select all trips information." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    if (_currentBusType.length > 0 && _currentBusNo.length > 0) {
        UIStoryboard* seatSB = [UIStoryboard getBusScheduleStoryboard];
        SeatReservationVC* seatvc = (SeatReservationVC*)[seatSB instantiateViewControllerWithIdentifier:@"SeatReservationVC"];
        seatvc.busnumber = _currentBusNo;
        seatvc.bustype = _currentBusType;
        seatvc.tripName = _btnSelectTrip.titleLabel.text;
        seatvc.tripDate = _btnSelectDate.titleLabel.text;
        seatvc.tripTime = _btnSelectTime.titleLabel.text;
        [self.navigationController pushViewController:seatvc animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select a bus." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    

}

- (void)selectBusTypeOnClicked:(NSNotification*)notification
{
}

- (void)busTypeRetured:(NSNotification*)noti
{
    NSDictionary* dict = (NSDictionary*)noti.object;
    NSString* str = dict[@"string"];
    [_myBtn setTitle:str forState:UIControlStateNormal];
    [_muDict setObject:str forKey:@(_currentindex)];
    [_mypopoverController dismissPopoverAnimated:YES];
}

- (void)selectFromBusSchedule:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnSelectTrip setTitle:str forState:UIControlStateNormal];
    [_mypopoverController dismissPopoverAnimated:YES];
}

- (void)selectDateFromBusSchedule:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnSelectDate setTitle:str forState:UIControlStateNormal];
    [_mypopoverController dismissPopoverAnimated:YES];

}

- (void)selectTimeFromBusSchedule:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnSelectTime setTitle:str forState:UIControlStateNormal];
    [_mypopoverController dismissPopoverAnimated:YES];
}

-(void)addDashedBorder:(UIView*)view
{
    //border definitions
    CGFloat cornerRadius = 0;
    CGFloat borderWidth = 1;
    NSInteger dashPattern1 = 4;
    NSInteger dashPattern2 = 4;
    UIColor *lineColor = [UIColor blackColor];
    
    //drawing
    CGRect frame = view.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [view.layer addSublayer:_shapeLayer];
    view.layer.cornerRadius = cornerRadius;
}


#pragma mark - UITableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_txtNumOfBus.text integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"buscell";
    BusCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[BusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, 150.0f, 40.0f);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Select Bus Type" forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(myAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusCell *cell = (BusCell *)[tableView cellForRowAtIndexPath:indexPath];
    _currentBusNo = cell.cellTxtBusNo.text;
//    UIButton *btnCell = (UIButton *) [cell.cellBtnBkgView viewWithTag:indexPath.row];
//    _currentBusType = btnCell.titleLabel.text;
    
    _currentBusType = [_muDict objectForKey:@(indexPath.row)];
}

- (void)myAction:(id)sender event:(id)event
{
    UIButton *btnCell = (UIButton*)sender;
    _myBtn = btnCell;
    _currentindex = btnCell.tag;
//    [btnCell setTitle:@"New Title" forState:UIControlStateNormal];
//    [_myBtn setTitle:@"New Title" forState:UIControlStateNormal];
    UIStoryboard *sb = [UIStoryboard getBusScheduleStoryboard];
    SelectBusTypeVC *detailController = (SelectBusTypeVC*)[sb instantiateViewControllerWithIdentifier:@"SelectBusTypeVC"];
    
    self.mypopoverController = [[UIPopoverController alloc] initWithContentViewController:detailController];
    
//    BusCell *cell = (BusCell*)notification.object;
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGPoint touchPosition = [[[event allTouches] anyObject] locationInView:_tvBusList];
    NSIndexPath *indexPath = [_tvBusList indexPathForRowAtPoint:touchPosition];
    BusCell *cell = (BusCell*)[_tvBusList cellForRowAtIndexPath:indexPath];
    [self.mypopoverController presentPopoverFromRect:cell.bounds inView:cell.contentView
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];

}
@end
