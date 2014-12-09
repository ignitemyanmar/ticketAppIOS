//
//  DetailSeatOccupacyVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DetailSeatOccupacyVC.h"
#import "SeatOccupacyCell.h"
#import "Seat.h"
#import "Reachability.h"

@interface DetailSeatOccupacyVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSString* documentDirectoryFilename;
@property (strong, nonatomic) NSArray* dataFiller;
@property (assign, nonatomic) int dataIndex;
@property (assign, nonatomic) int currentSeatNum;
@property (strong, nonatomic) NSIndexPath* path;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UICollectionView *collViewDetailSeat;


@end

@implementation DetailSeatOccupacyVC

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
    
    self.title = @"Detail Seat Report";
        
    _dataIndex = 0;
    
    UIButton *righBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    righBtn.frame = CGRectMake(0, 0, 50, 50);
    //    [filter setBackgroundImage:[UIImage imageNamed:@"filters"] forState:UIControlStateNormal];
    [righBtn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    [righBtn setTitle:@"Print" forState:UIControlStateNormal];
    [righBtn addTarget:self action:@selector(printOnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:righBtn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarBtn, nil]];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printOnClicked
{
    //PRINT
    UIImage *finalImg = [self convertCollectionViewToImage];
    [self createPdf:finalImg];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (UIImage*)convertCollectionViewToImage
{
    UIImage *tempImg = [self renderScrollViewToImage];
    UIImage *resizedImg = [UIImage imageWithCGImage:[tempImg CGImage] scale:(tempImg.scale * 3.0) orientation:(tempImg.imageOrientation)];
    return resizedImg;
}

- (UIImage *)renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_collViewDetailSeat.contentSize);
    {
        CGPoint savedContentOffset = _collViewDetailSeat.contentOffset;
        CGRect savedFrame = _collViewDetailSeat.frame;
        
        _collViewDetailSeat.contentOffset = CGPointZero;
        _collViewDetailSeat.frame = CGRectMake(0, 0, _collViewDetailSeat.contentSize.width, _collViewDetailSeat.contentSize.height);
        
        [_collViewDetailSeat.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _collViewDetailSeat.contentOffset = savedContentOffset;
        _collViewDetailSeat.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    return image;
}

-  (void)createPdf:(UIImage *)img
{
    //a4
    CGRect pdfPageBounds = CGRectMake(0, 0, 595, 700); //
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
        [img drawAtPoint:CGPointMake(5,5)];
    } UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"SeatReportDetail.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
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
    NSString* cellid = @"seatOccupacyCell";
    SeatOccupacyCell* cell = (SeatOccupacyCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    NSArray* tempArr = _seatStatus[indexPath.section];
    
    cell.cellLblName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblNrc.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if ([tempArr[indexPath.item] isEqualToString:@"1"]) {
        cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
        
        cell.cellLblNrc.hidden = YES;
        cell.cellLblName.hidden = YES;

    }
    else if ([tempArr[indexPath.item] isEqualToString:@"0"])
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.layer.borderWidth = 0;
        
        cell.cellLblNrc.hidden = YES;
        cell.cellLblName.hidden = YES;
        
    }
    else if ([tempArr[indexPath.item] isEqualToString:@"2"])
    {
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        self.reachable = [self.reachability currentReachabilityStatus];

        cell.backgroundColor = [UIColor redColor];
        cell.cellLblNrc.hidden = NO;
        cell.cellLblName.hidden = NO;
        
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;
        
        
        NSArray* seatColArr = _seatObjs[indexPath.section];
        Seat* seatobj = seatColArr[indexPath.row];
        NSDictionary* customer = seatobj.customer;
//        NSDictionary* tempdict = _dataFiller[_dataIndex];
        if (customer) {
            cell.cellLblName.text = customer[@"name"];//tempdict[@"name"];
            cell.cellLblNrc.text = customer[@"nrc"];//tempdict[@"nrc"];
        }
        else if (!(customer && self.reachable)) {
            
            cell.cellLblName.text = @"U BA";
            cell.cellLblNrc.text = @"12/LaMaTa(N)123456";
        }
    
        if (_dataIndex < _dataFiller.count-1) {
            _dataIndex++;
        }
        else
        {
            _dataIndex = 0;
        }
        
    }
    
    if (indexPath == _path) {
        cell.backgroundColor = [UIColor blackColor];
        cell.cellLblNrc.hidden = NO;
        cell.cellLblName.hidden = NO;
    }
    
    if (self.currentSeatNum < _seatStatus.count-1) {
        self.currentSeatNum++;
    } else self.currentSeatNum = 0;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _path = indexPath;
}


@end
