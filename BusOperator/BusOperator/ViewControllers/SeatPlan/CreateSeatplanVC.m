//
//  CreateSeatplanVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/3/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreateSeatplanVC.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"

@interface CreateSeatplanVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) NSInteger numCol;
@property (assign, nonatomic) NSInteger numRow;
@property (strong, nonatomic) NSIndexPath* currentindexPath;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (assign, nonatomic) BOOL isFirstLoad;

@property (strong, nonatomic) NSMutableArray* statusArr;
@property (strong, nonatomic) IBOutlet UICollectionView *colView;
@property (strong, nonatomic) IBOutlet UITextField *txtRow;
@property (strong, nonatomic) IBOutlet UITextField *txtCol;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *colViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateLayout;

- (IBAction)CreateLayout:(id)sender;

@end

@implementation CreateSeatplanVC

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
    [button addTarget:self action:@selector(addSeatPlan) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;

    
    _isFirstLoad = YES;
    _statusArr = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCreateSeatLayout:) name:@"finishCreateSeatLayout" object:nil]; //STARTing Point createSeatLayout Notification callback :)
    
    _btnCreateLayout.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnCreateLayout setTitle:@"ထုုိင္ခံုုေနရာခ်ပါ" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSeatPlan
{
    int totalCount = 0;
    NSMutableString* strStatus = [NSMutableString new];
    for (int i =0; i < _statusArr.count; i++) {
        if (i == _statusArr.count-1) {
            [strStatus appendString:_statusArr[i]];
        }
        else {
            [strStatus appendFormat:@"%@,",_statusArr[i]];
        }
        NSString* str = _statusArr[i];
        if ([str isEqualToString:@"1"]) {
            totalCount++;
        }
    }
    
    NSLog(@"%@",strStatus);
    if (totalCount > 0) {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher createSeatlayoutwithTicketid:1 withrow:_numRow withCol:_numCol withStatus:strStatus];
    }
    else {
        
        [self JDStatusBarHidden:NO status:@"Position seats in layout!" duration:3];
    }
    
}

- (void)finishCreateSeatLayout:(NSNotification*)noti
{
//    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSDictionary* dict = (NSDictionary*)noti.object;
    [self JDStatusBarHidden:NO status:dict[@"message"] duration:3];
    
}

- (NSString*)seatNameGenerator:(int)multiplier
{
    NSString *str;
    switch (multiplier) {
        case 1:
            str = @"A";
            break;
            
        case 2:
            str = @"B";
            break;
            
        case 3:
            str = @"C";
            break;
            
        case 4:
            str = @"D";
            break;
            
        case 5:
            str = @"E";
            break;
            
        case 6:
            str = @"F";
            break;
            
        case 7:
            str = @"G";
            break;
            
        case 8:
            str = @"H";
            break;
            
        case 9:
            str = @"I";
            break;
            
        case 10:
            str = @"J";
            break;
            
        case 11:
            str = @"K";
            break;
            
        case 12:
            str = @"L";
            break;
            
        default:
            break;
    }
    return str;
}

//- (void)finishCreateSeatPlan:(NSNotification*)noti
//{
//    NSDictionary* dict = (NSDictionary*)noti.object;
//    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:dict[@"message"] message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alert show];
//    
//}

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
    NSString* colid = @"colCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:colid forIndexPath:indexPath];
    if (_isFirstLoad) {
        cell.backgroundColor = [UIColor grayColor];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1.5f;
        
        [_statusArr addObject:@"0"];
    }
    else {
        int curSeatNum = indexPath.section * _numCol + indexPath.item;
        BOOL isAlreadyFound = NO;
        NSArray* selectedindexes = [_indexArray copy];
        for (NSIndexPath* ip in selectedindexes) {
            if (ip.section == indexPath.section && ip.item == indexPath.item) {
                [_indexArray removeObject:ip];
                isAlreadyFound = YES;
                
                cell.backgroundColor = [UIColor grayColor];
                cell.layer.borderColor = [[UIColor blackColor] CGColor];
                cell.layer.borderWidth = 1.5f;
                
                if (curSeatNum < _statusArr.count) {
                    [_statusArr replaceObjectAtIndex:curSeatNum withObject:@"0"];
                }
                
                break;
            }
        }
        
        if (!isAlreadyFound) {
            if (_currentindexPath.section == indexPath.section && _currentindexPath.item == indexPath.item) {
                [_indexArray addObject:indexPath];
                
                cell.backgroundColor = [UIColor blueColor];
                cell.layer.borderColor = [[UIColor greenColor] CGColor];
                cell.layer.borderWidth = 1.5f;
                if (curSeatNum < _statusArr.count) {
                    [_statusArr replaceObjectAtIndex:curSeatNum withObject:@"1"];
                }
            }
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = _colView.frame.size.width/_numCol;
    return CGSizeMake(cellWidth, cellWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isFirstLoad = NO;
    _currentindexPath = indexPath;
    
    [_colView reloadItemsAtIndexPaths:@[indexPath]];
}

- (IBAction)CreateLayout:(id)sender {
    if ((_txtCol.text.length > 0) && (_txtRow.text.length > 0))
    {
        if ([self stringIsNumeric:_txtRow.text] && [self stringIsNumeric:_txtCol.text])
        {
            _numCol = [_txtCol.text integerValue];
            _numRow = [_txtRow.text integerValue];
            if ((_numCol > 0) && (_numRow > 0)) {
                _indexArray = [NSMutableArray new];
                
                CGFloat cellHeight = _colView.frame.size.width/_numCol;
                CGFloat resultheight = cellHeight*_numRow;
                
                _colViewHeight.constant = resultheight;
                
                _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, resultheight+100);
                _isFirstLoad = YES;
                
                [_colView reloadData];
                
                _statusArr = [NSMutableArray new];
            }
            
            

        }
    }
    
}

-(BOOL) stringIsNumeric:(NSString *) str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}
@end
