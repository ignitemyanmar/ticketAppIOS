//
//  CreateSeatVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreateSeatVC.h"
#import "SeatlayoutCell.h"
#import "DataFetcher.h"
#import "AddSeatNameVC.h"
#import "JDStatusBarNotification.h"
#import "customCollcell.h"

@interface CreateSeatVC () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collviewheight;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *collSeatView;
@property (strong, nonatomic) IBOutlet UITableView *tbSeatLayout;
@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) NSMutableArray* totalSeatcount;
@property (strong, nonatomic) NSMutableArray* muSeatStaus;
@property (assign, nonatomic) int numRow;
@property (assign, nonatomic) int numCol;
@property (strong, nonatomic) NSMutableArray* mySeatStatus;
@property (strong, nonatomic) NSArray* seatStatus;
@property (strong, nonatomic) NSMutableArray* seatName;
@property (strong, nonatomic) UIPopoverController* mypopoverController;
@property (strong, nonatomic) NSIndexPath* selectedindexpath;
@property (strong, nonatomic) NSMutableArray* seatlblArr;
@property (assign, nonatomic) int layoutid;

@end

@implementation CreateSeatVC

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
    
    [button setTitle:@"Save Seat Plan" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5.0f;
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 150, 40);
    [button addTarget:self action:@selector(SaveSeatPlan) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetSeatLayoutList:) name:@"finishGetSeatLayoutList" object:nil];
    
    _numCol = 0;
    _numRow = 0;
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getSeatLayoutList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAddingSeatName:) name:@"finishAddingSeatName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateSeatPlan:) name:@"finishCreateSeatPlan" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetSeatLayoutList:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    NSArray * result = [[NSArray alloc] init];
    _muSeatStaus = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in tempArr)
    {
        NSString* layoutStr = dict[@"seat_list"];
        result = [layoutStr componentsSeparatedByString:@","];
        [_muSeatStaus addObject:result];
    }
    NSLog(@"The _muSeatStatus string is %@", _muSeatStaus);
    
    //[yourString stringByReplacingOccurrencesOfString:@" " withString:@""]
    _totalSeatcount = [[NSMutableArray alloc] initWithCapacity:_muSeatStaus.count];
    for (NSArray* arr in _muSeatStaus) {
        int totalCount = 0;
        for (NSString* str in arr) {
//            [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray* words = [str componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
            NSString* nospacestring = [words componentsJoinedByString:@""];
            if ([nospacestring isEqualToString:@"1"]) {
                totalCount++;
            }
        }
        NSString* strCount = [NSString stringWithFormat:@"%d",totalCount];
        [_totalSeatcount addObject:strCount];
    }
     NSLog(@"The totalSeatcount is %@", _totalSeatcount);
    
    [_tbSeatLayout reloadData];
    
    _mySeatStatus = [NSMutableArray new];
    
    NSMutableArray* mySeat;
    NSMutableArray* rowSeat;
    for (int outerCount=0; outerCount < tempArr.count; outerCount++) {
        NSDictionary* dict = tempArr[outerCount];
        int totalCol = [dict[@"column"] intValue];
        int totalRow = [dict[@"row"] intValue];

        int totalCount = 0;

        mySeat = [NSMutableArray new];
        rowSeat = [NSMutableArray new];
        for (int i = 0; i < totalRow; i++) {
           
            NSMutableArray* status = [NSMutableArray new];
            for (int j = 0; j < totalCol; j++) {
                NSArray* arrStatus = _muSeatStaus[outerCount];
                NSString* strStatus = arrStatus[totalCount];
                [status addObject:strStatus];
                
                totalCount++;
            }
            [mySeat addObject:status];
            
        }
        [_mySeatStatus addObject:mySeat];
        
    }

    NSLog(@"mySeatStatus Arr is %@", _mySeatStatus);
}

- (void)finishAddingSeatName:(NSNotification*)noti
{
    NSString* strReturn = (NSString*)noti.object;
    customCollcell *cell = (customCollcell*)[_collSeatView cellForItemAtIndexPath:_selectedindexpath];
    cell.cellLblTitle.hidden = NO;
    cell.cellLblTitle.text = strReturn;
    
    [self.mypopoverController dismissPopoverAnimated:YES];
    
    int curSeatNum = _selectedindexpath.section * _numCol + _selectedindexpath.item;
    [_seatName replaceObjectAtIndex:curSeatNum withObject:strReturn];
}

- (void)finishCreateSeatPlan:(NSNotification*)noti
{
    NSString* msg = (NSString*)noti.object;
    [self JDStatusBarHidden:YES status:msg duration:0];
}

- (void)SaveSeatPlan
{
    NSMutableString* muStr = [NSMutableString new];
    [muStr appendString:@"["];

    for (int i = 0; i < _seatName.count; i++) {
        NSString* str = _seatName[i];
        if ([str isEqualToString:@""]) {
            [self JDStatusBarHidden:NO status:@"All seats must be named to save seat plan!" duration:4];
            return;
        }
        else {
            
            int status = 1;
            if ([str isEqualToString:@"xxx"]) {
                status = 0;
            }
            if (i == _seatName.count-1) {
                [muStr appendFormat:@"{\"seat_no\":\"%@\", \"status\":%d}]",str,status];
            }
            else {
                [muStr appendFormat:@"{\"seat_no\":\"%@\", \"status\":%d},",str,status];
            }
            
        }
    }
    
     NSLog(@"Final String is %@", muStr);
    [self JDStatusBarHidden:NO status:@"Saving seat plan..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher createSeatPlanWithTicketid:1 withOpid:1 withrow:_numRow withCol:_numCol withLayoutid:_layoutid withSeatList:muStr];
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
    NSString* cellid = @"SeatlayoutCell";
    SeatlayoutCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellColCount.text = [NSString stringWithFormat:@"Column = %@",dict[@"column"]];
    cell.cellRowCount.text = [NSString stringWithFormat:@"Row = %@",dict[@"row"]];
    cell.cellTotalSeat.text = [NSString stringWithFormat:@"Total Seat = %@",_totalSeatcount[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = _dataFiller[indexPath.row];
    _numRow = [dict[@"row"] intValue];
    _numCol = [dict[@"column"] intValue];
    _seatStatus = _mySeatStatus[indexPath.row];
    
    CGFloat cellHeight = _collSeatView.frame.size.width/_numCol;
    CGFloat resultheight = cellHeight*_numRow;
    
    _collviewheight.constant = resultheight;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, resultheight+100);
    
    [_collSeatView reloadData];
    
    NSArray* currentStatusArr = _muSeatStaus[indexPath.row];
    NSLog(@"currentStatusArr is %@",currentStatusArr);
    _seatName = [[NSMutableArray alloc] initWithCapacity:currentStatusArr.count];
    for (int i = 0; i < currentStatusArr.count; i++) {
        NSString* str = currentStatusArr[i];
        NSArray* words = [str componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
        NSString* nospacestring = [words componentsJoinedByString:@""];
        if ([nospacestring isEqualToString:@"0"]) {
            [_seatName addObject:@"xxx"];
        }
        else {
            [_seatName addObject:@""];
        }

    }
    
    for (UILabel* lbl in _seatlblArr) {
     [lbl removeFromSuperview];
    }
    _seatlblArr = [NSMutableArray new];
    
    _layoutid = [dict[@"id"] intValue];
}

#pragma mark - UICollectionview Methods
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
    NSString* cellid = @"seatplan_colcell";
    customCollcell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.cellLblTitle.hidden = YES;
    NSArray* tempArr = _seatStatus[indexPath.section];
    NSString* strStatus = tempArr[indexPath.item];
    NSArray* words = [strStatus componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    NSString* nospacestring = [words componentsJoinedByString:@""];
    
    if ([nospacestring isEqualToString:@"1"]) {
        cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
    }
    else if ([nospacestring isEqualToString:@"0"])
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.layer.borderWidth = 0;
        
    }
    else if ([nospacestring isEqualToString:@"2"])
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
    CGFloat cellWidth = _collSeatView.frame.size.width/_numCol;
    return CGSizeMake(cellWidth, cellWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* tempArr = _seatStatus[indexPath.section];
    NSString* strStatus = tempArr[indexPath.item];
    NSArray* words = [strStatus componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    NSString* nospacestring = [words componentsJoinedByString:@""];
    
    if ([nospacestring isEqualToString:@"1"]) {
        AddSeatNameVC *detailController = (AddSeatNameVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddSeatNameVC"];
        
        self.mypopoverController = [[UIPopoverController alloc] initWithContentViewController:detailController];
        
        customCollcell *cell = (customCollcell*)[_collSeatView cellForItemAtIndexPath:indexPath];
        detailController.seatno = cell.cellLblTitle.text;
        
        [self.mypopoverController presentPopoverFromRect:cell.bounds inView:cell.contentView
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];
        _selectedindexpath = indexPath;
    }
}



@end
