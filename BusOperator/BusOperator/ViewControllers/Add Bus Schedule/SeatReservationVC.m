//
//  SeatReservationVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SeatReservationVC.h"

@interface SeatReservationVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *bkgInfoView;
@property (strong, nonatomic) IBOutlet UICollectionView *collViewSeat;
@property (strong, nonatomic) IBOutlet UIView *bkgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblBusNum;
@property (strong, nonatomic) IBOutlet UILabel *lblBusType;

@property (strong, nonatomic) NSArray* seatStatus;
@property (strong, nonatomic) NSMutableArray* selectedIndexPath;
@property (assign, nonatomic) BOOL isFirstLoad;


@end

@implementation SeatReservationVC

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
    
    self.title = @"Seat Reservation";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    _seatStatus = @[@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"],@[@"0",@"0",@"3",@"0",@"0"]];
    
    _selectedIndexPath = [[NSMutableArray alloc] init];
    
    _isFirstLoad = YES;
    
    UIButton *righBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    righBtn.frame = CGRectMake(0, 0, 150, 50);
    [righBtn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    [righBtn setTitle:@"Save Reservation" forState:UIControlStateNormal];
    [righBtn addTarget:self action:@selector(saveReservation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:righBtn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarBtn, nil]];
    
    [self addDashedBorder:_bkgView];
    [self addDashedBorder:_bkgInfoView];
    
    _lblBusNum.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusType.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblBusNum.text = _busnumber;
    _lblBusType.text = _bustype;
    _lblTripName.text = _tripName;
    _lblDate.text = _tripDate;
    _lblTime.text = _tripTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveReservation
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Successfully saved." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"seatReserveCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    BOOL isAlreadySelected = NO;
    
    NSArray* tempArr = _seatStatus[indexPath.section];
    
    if (_isFirstLoad) {
        if ([tempArr[indexPath.item] isEqualToString:@"0"]) {
            cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
            cell.layer.borderColor = [[UIColor blackColor] CGColor];
            cell.layer.borderWidth = 1;
        }
        else if ([tempArr[indexPath.item] isEqualToString:@"3"])
        {
            cell.backgroundColor = [UIColor clearColor];
            cell.layer.borderColor = [[UIColor clearColor] CGColor];
            cell.layer.borderWidth = 0;
            
        }
        else if ([tempArr[indexPath.item] isEqualToString:@"2"])
        {
            cell.backgroundColor = [UIColor redColor];
            cell.layer.borderColor = [[UIColor blackColor] CGColor];
            cell.layer.borderWidth = 1;
            
        }

    }
    else
    {
        if (![tempArr[indexPath.item] isEqualToString:@"3"]) {
            NSMutableArray *temparr = [_selectedIndexPath mutableCopy];
            
            for (NSDictionary* dict in temparr)
            {
                NSInteger curItem = [dict[@"item"] integerValue];
                NSInteger curSection = [dict[@"section"] integerValue];
                if (curItem == indexPath.item && curSection == indexPath.section) {
                    isAlreadySelected = YES;
                    [_selectedIndexPath removeObject:dict];
                    //                cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
                    cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
                    break;
                }
            }
            
            
            
            if (!isAlreadySelected) {
                cell.backgroundColor = [UIColor colorWithRed:82.0/255 green:199.0/255 blue:137.0/255 alpha:1];
                NSDictionary* dict = @{@"section": @(indexPath.section), @"item": @(indexPath.item)};
                [_selectedIndexPath addObject:dict];
            }
            
            cell.layer.borderColor = [[UIColor blackColor] CGColor];
            cell.layer.borderWidth = 1;

        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
            cell.layer.borderColor = [[UIColor clearColor] CGColor];
            cell.layer.borderWidth = 0;
        }
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _isFirstLoad = NO;
    [_collViewSeat reloadItemsAtIndexPaths:@[indexPath]];
}

@end
