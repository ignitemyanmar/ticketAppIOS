
//
//  SeatOccupacyReportVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SeatOccupacyReportVC.h"
#import "MultiLineSegmentedControl.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "DetailSeatOccupacyVC.h"
#import "DataFetcher.h"
#import "TripListVC.h"
#import "TripTimeListVC.h"
#import "City.h"
#import "SeatPlan.h"
#import "Seat.h"
#import "JDStatusBarNotification.h"
#import "Reachability.h"
#import "SeatOccupacyCell.h"

@interface SeatOccupacyReportVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray* seatStatus;
@property (assign, nonatomic) int currentSeatNum;
@property (strong, nonatomic) MultiLineSegmentedControl* segControl;
@property (assign, nonatomic) int selectedSegControl;

@property (strong, nonatomic) UIPopoverController* myPopoverController;

@property (strong, nonatomic) NSArray* fromCityList;
@property (strong, nonatomic) NSArray* toCityList;
@property (strong, nonatomic) NSArray* timeStrArr;
@property (strong, nonatomic) NSString* strpopoverview;
@property (strong, nonatomic) City* currentFromCity;
@property (strong, nonatomic) City* currentToCity;
@property (strong, nonatomic) City* fromCity;
@property (strong, nonatomic) City* toCity;
@property (strong, nonatomic) NSString* strDate;
@property (assign, nonatomic) int numRow;
@property (assign, nonatomic) int numCol;
@property (strong, nonatomic) NSMutableArray* mySeatStatus;
@property (strong, nonatomic) NSMutableArray* mySeatObjs;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UIView *bkgBtnView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnToDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTime;

@property (strong, nonatomic) IBOutlet UIView *bkgSeatView;
@property (strong, nonatomic) IBOutlet UIView *bkgSegControlView;
@property (strong, nonatomic) IBOutlet UICollectionView *colViewSeat;
@property (strong, nonatomic) IBOutlet UIButton *btnViewDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverseat;

@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UILabel *lblNoBus;

- (IBAction)SearchSeatPlan:(id)sender;
- (IBAction)btnViewDetailOnclicked:(id)sender;
- (IBAction)onFromCityClick:(id)sender;
- (IBAction)onToCityClick:(id)sender;

@end

@implementation SeatOccupacyReportVC

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
    
    self.title = @"Seat Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
//    _seatStatus = @[@[@"0",@"2",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"2",@"2",@"3",@"0",@"0"],@[@"2",@"2",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"]];
    
    _currentSeatNum = 0;
    
    _numCol = 0;
    _numRow = 0;
    
    
    [self addDashedBorder:_bkgBtnView];
    [self addDashedBorder:_bkgSeatView];
    _btnViewDetail.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnViewDetail.layer.borderWidth = 1.5;
    _btnViewDetail.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTripFromSeatReport:) name:@"selectTripFromSeatReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTimeFromSeatReport:) name:@"selectTimeFromSeatReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFromDateFromSeatReport:) name:@"selectFromDateFromSeatReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectToDateFromSeatReport:) name:@"selectToDateFromSeatReport" object:nil];
    
    _bkgSegControlView.hidden = YES;
    _colViewSeat.hidden = YES;
    _btnViewDetail.hidden = YES;
    _lblDriverseat.hidden = YES;
    _lblNoBus.hidden = YES;
    
    _btnSelectTrip.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTrip setTitle:@"ခရီးစဥ္အစ ေရြးပါ" forState:UIControlStateNormal];
    
    _btnSelectTime.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSelectTime setTitle:@"ကားထြက္ခ်ိန္" forState:UIControlStateNormal];
    
    _btnFromDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnFromDate setTitle:@"ခရီးစဥ္အဆံုုး ေရြးပါ" forState:UIControlStateNormal];
    
    _btnToDate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnToDate setTitle:@"ေန ့ရက္ ေရြးပါ" forState:UIControlStateNormal];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCityDownloadSeatReport:) name:@"finishCityListByOpid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetTimeSeatReport:) name:@"finishGetTimeWithOpid" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReportSeatplanDownload:) name:@"finishReportSeatplanDownload" object:nil];
    
    if (self.reachable) {
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getCitiesWithOpid];
        [fetcher getTimeWithOpid];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"seatoccupacyreportvc" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (void)finishCityDownloadSeatReport:(NSNotification*)noti
{
    NSDictionary* tempDict = (NSDictionary*)noti.object;
    NSArray* fromArr = tempDict[@"fromCity"];
    _fromCityList = [fromArr copy];
    NSArray* toArr = tempDict[@"toCity"];
    _toCityList = [toArr copy];

}

- (void)finishGetTimeSeatReport:(NSNotification*)noti
{
    _timeStrArr = (NSArray*)noti.object;
}

- (void)finishReportSeatplanDownload:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    
    NSArray* tempArr = (NSArray*)noti.object;
    NSMutableArray* segTitle = [NSMutableArray new];
    _mySeatStatus = [NSMutableArray new];
    _mySeatObjs = [NSMutableArray new];
    NSMutableArray* mySeat;
    NSMutableArray* rowSeat;
    for (SeatPlan* planObj in tempArr) {
        NSString* strSeg = [NSString stringWithFormat:@"%@-%@",planObj.bus_no,planObj.classes];
        [segTitle addObject:strSeg];
        int totalCol = [planObj.column intValue];
        int totalRow = [planObj.row intValue];
        int totalSeat =  totalRow + totalCol;
        int totalCount = 0;
        NSArray* seatArr = planObj.seat_list;
        mySeat = [NSMutableArray new];
        rowSeat = [NSMutableArray new];
        for (int i = 0; i < totalRow; i++) {
            NSMutableArray* seat = [NSMutableArray new];
            NSMutableArray* status = [NSMutableArray new];
            for (int j = 0; j < totalCol; j++) {
                Seat* seatObj = seatArr[totalCount];
                [status addObject:seatObj.status];
                [seat addObject:seatObj];
                totalCount++;
            }
            [mySeat addObject:status];
            [rowSeat addObject:seat];
        }
        [_mySeatStatus addObject:mySeat];
        [_mySeatObjs addObject:rowSeat];
    }
    
    NSLog(@"mySeatStatus = %@",_mySeatStatus);
    
    if (tempArr.count > 0) {
        _bkgSegControlView.hidden = NO;
        _colViewSeat.hidden = NO;
        _btnViewDetail.hidden = NO;
        _lblDriverseat.hidden = NO;
        _lblNoBus.hidden = YES;
        
        _segControl = [[MultiLineSegmentedControl alloc] initWithItems:segTitle];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Zawgyi-One" size:14.0f], NSFontAttributeName,
                                    [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [_segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        _segControl.frame = CGRectMake(0, 0, 400, _segControl.frame.size.height * 2.5);
        
        
        
        [_segControl addTarget:self action:@selector(changeSegmentControlValue) forControlEvents:UIControlEventValueChanged];
        
        [_bkgSegControlView addSubview:_segControl];
        _segControl.center = [_bkgSegControlView convertPoint:_bkgSegControlView.center fromView:_bkgSegControlView.superview];
        
        _segControl.selectedSegmentIndex = 0;
        _selectedSegControl = 0;
        
        SeatPlan* planObj = tempArr[0];
        _numRow = [planObj.row intValue];
        _numCol = [planObj.column intValue];
        _seatStatus = _mySeatStatus[0];
        
        [_colViewSeat reloadData];

    }
    else {
        _bkgSegControlView.hidden = YES;
        _colViewSeat.hidden = YES;
        _btnViewDetail.hidden = YES;
        _lblDriverseat.hidden = YES;
        
        _lblNoBus.hidden = NO;
        
        _numRow = 0;
        _numCol = 0;
        [_colViewSeat reloadData];
    }


}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    if (self.reachable) {
        if ([segue.identifier isEqualToString:@"fromCitySegue"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_fromCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"toCitySegue"]) {
            
            TripListVC* triplistvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triplistvc.tripList = [_toCityList copy];
        }
        else if ([segue.identifier isEqualToString:@"timeSegue"])
        {
            TripTimeListVC* triptimelist = [(UIStoryboardPopoverSegue *)segue destinationViewController];
            triptimelist.tripList = [_timeStrArr mutableCopy];
        }

    }
    
}


- (void)changeSegmentControlValue
{
    _seatStatus = _mySeatStatus[_segControl.selectedSegmentIndex];
    [_colViewSeat reloadData];
    
}

- (void)selectTripFromSeatReport:(NSNotification*)notification
{
    if (self.reachable) {
        City* city = (City*)notification.object;
        if ([_strpopoverview isEqualToString:@"FromCity"]) {
            [_btnSelectTrip setTitle:city.name forState:UIControlStateNormal];
            _currentFromCity = city;
        }
        else {
            [_btnFromDate setTitle:city.name forState:UIControlStateNormal];
            _currentToCity = city;
        }

    }
    else {
        NSString* str = (NSString*)notification.object;
        if ([_strpopoverview isEqualToString:@"FromCity"]) {
            [_btnSelectTrip setTitle:str forState:UIControlStateNormal];
        }
        else {
            [_btnFromDate setTitle:str forState:UIControlStateNormal];
        }
    }
    [_myPopoverController dismissPopoverAnimated:YES];

}

- (void)selectTimeFromSeatReport:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectTime setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)selectFromDateFromSeatReport:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnFromDate setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)selectToDateFromSeatReport:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnToDate setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
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


#pragma mark - UICollectionView Methods
- (IBAction)SearchSeatPlan:(id)sender {
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
        _fromCity = _currentFromCity;
        _toCity = _currentToCity;
        _strDate = _btnToDate.titleLabel.text;
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getReportSeatPlan:1 withFromCity:_currentFromCity.id withToCity:_currentToCity.id withDate:_strDate withTime:_btnSelectTime.titleLabel.text];
    }
    else {
        _bkgSegControlView.hidden = NO;
        _colViewSeat.hidden = NO;
        _btnViewDetail.hidden = NO;
        _lblDriverseat.hidden = NO;
        _lblNoBus.hidden = YES;
        
        NSArray* segTitle = @[@"YGN-1234"];
        _segControl = [[MultiLineSegmentedControl alloc] initWithItems:segTitle];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Zawgyi-One" size:14.0f], NSFontAttributeName,
                                    [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [_segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        _segControl.frame = CGRectMake(0, 0, 400, _segControl.frame.size.height * 2.5);
        
        
        
        [_segControl addTarget:self action:@selector(changeSegmentControlValue) forControlEvents:UIControlEventValueChanged];
        
        [_bkgSegControlView addSubview:_segControl];
        _segControl.center = [_bkgSegControlView convertPoint:_bkgSegControlView.center fromView:_bkgSegControlView.superview];
        
        _segControl.selectedSegmentIndex = 0;
        _selectedSegControl = 0;

        
        _seatStatus = @[@[@"1",@"2",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"],@[@"1",@"1",@"0",@"1",@"1"]];
        _numCol = 5;
        _numRow = 12;
        [_colViewSeat reloadData];
    }
    
   
}

- (IBAction)btnViewDetailOnclicked:(id)sender {
    
//    UIStoryboard* seatSB = [UIStoryboard getSeatOccupacyStoryboard];
    DetailSeatOccupacyVC* seatvc = (DetailSeatOccupacyVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailSeatOccupacyVC"];
    seatvc.seatStatus = _seatStatus;
    seatvc.seatObjs = _mySeatObjs[_segControl.selectedSegmentIndex];
    seatvc.numCol = _numCol;
    seatvc.numRow = _numRow;
    [self.navigationController pushViewController:seatvc animated:YES];
}

- (IBAction)onFromCityClick:(id)sender {
    _strpopoverview = @"FromCity";
}

- (IBAction)onToCityClick:(id)sender {
    _strpopoverview = @"toCity";
}

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
    NSString* cellid = @"seatCell";
    SeatOccupacyCell* cell = (SeatOccupacyCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    NSArray* tempArr = _seatStatus[indexPath.section];
    NSArray* tempseatArr = _mySeatObjs[0];
    NSArray* seatArr = tempseatArr[indexPath.section];
    
    if ([tempArr[indexPath.item] isEqualToString:@"1"]) {
        cell.cellLblName.hidden = NO;
        Seat* myseatobj = seatArr[indexPath.item];
        cell.cellLblName.text = myseatobj.seat_no;
        cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
    }
    else if ([tempArr[indexPath.item] isEqualToString:@"0"])
    {
        cell.cellLblName.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.layer.borderWidth = 0;

    }
    else if ([tempArr[indexPath.item] isEqualToString:@"2"])
    {
        cell.cellLblName.hidden = NO;
        Seat* myseatobj = seatArr[indexPath.item];
        cell.cellLblName.text = myseatobj.seat_no;
        cell.backgroundColor = [UIColor redColor];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
        
    }
    
//    if (self.currentSeatNum < _seatStatus.count-1) {
//        self.currentSeatNum++;
//    } else self.currentSeatNum = 0;
    
    return cell;
}

@end
